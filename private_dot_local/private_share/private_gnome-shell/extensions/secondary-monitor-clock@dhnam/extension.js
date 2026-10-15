// 주 모니터가 아닌 모니터마다 오른쪽 아래에 작은 시계(시간, 날짜)를 띄운다. Windows 작업 표시줄의 시계처럼.
//
// GNOME의 시계는 주 모니터의 위쪽 막대에만 있다. Ubuntu Dock이 아래에 고정(dock-fixed)되어 있으면
// 그 띠는 작업 영역 밖이라 창이 덮지 않으므로, 띠 안에 세로 가운데로 놓는다. 띠가 없으면 모서리에 띄운다.
// 시각 형식은 위쪽 막대 설정(clock-format, clock-show-seconds)을 따르고, 갱신은 같은 WallClock에 맞춘다.
import Clutter from 'gi://Clutter';
import GLib from 'gi://GLib';
import Gio from 'gi://Gio';
import GnomeDesktop from 'gi://GnomeDesktop';
import St from 'gi://St';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

const MARGIN = 8;

export default class SecondaryMonitorClock extends Extension {
    enable() {
        this._clocks = [];
        this._interface = new Gio.Settings({schema_id: 'org.gnome.desktop.interface'});
        this._interface.connectObject(
            'changed::clock-format', () => this._updateText(),
            'changed::clock-show-seconds', () => this._updateText(),
            this);
        this._wallClock = new GnomeDesktop.WallClock();
        this._wallClock.connectObject('notify::clock', () => this._updateText(), this);

        Main.layoutManager.connectObject('monitors-changed', () => this._rebuild(), this);
        global.display.connectObject('workareas-changed', () => this._placeAll(), this);
        this._rebuild();
    }

    disable() {
        Main.layoutManager.disconnectObject(this);
        global.display.disconnectObject(this);
        this._wallClock?.disconnectObject(this);
        this._interface?.disconnectObject(this);
        this._destroyClocks();
        this._wallClock = null;
        this._interface = null;
        this._clocks = null;
    }

    _rebuild() {
        this._destroyClocks();
        const layout = Main.layoutManager;
        for (const monitor of layout.monitors) {
            if (monitor.index === layout.primaryIndex)
                continue;

            const box = new St.BoxLayout({
                style_class: 'secondary-monitor-clock',
                orientation: Clutter.Orientation.VERTICAL,
            });
            const time = new St.Label({
                style_class: 'secondary-monitor-clock-time',
                x_align: Clutter.ActorAlign.CENTER,
            });
            const date = new St.Label({
                style_class: 'secondary-monitor-clock-date',
                x_align: Clutter.ActorAlign.CENTER,
            });
            box.add_child(time);
            box.add_child(date);
            // reactive가 아니므로 클릭은 아래로 통과한다. 그 모니터가 전체 화면이면 숨긴다
            layout.addChrome(box, {trackFullscreen: true});

            const clock = {box, time, date, monitorIndex: monitor.index};
            box.connectObject(
                'notify::width', () => this._place(clock),
                'notify::height', () => this._place(clock),
                this);
            this._clocks.push(clock);
        }
        this._updateText();
        this._placeAll();
    }

    _destroyClocks() {
        for (const clock of this._clocks ?? [])
            clock.box.destroy();
        if (this._clocks)
            this._clocks = [];
    }

    _updateText() {
        if (!this._clocks?.length)
            return;
        const now = GLib.DateTime.new_now_local();
        const seconds = this._interface.get_boolean('clock-show-seconds');
        const twelveHour = this._interface.get_string('clock-format') === '12h';
        const format = twelveHour
            ? (seconds ? '%p %l:%M:%S' : '%p %l:%M')
            : (seconds ? '%H:%M:%S' : '%H:%M');
        const time = now.format(format).replace(/\s+/g, ' ').trim();
        const date = now.format('%Y-%m-%d');
        for (const clock of this._clocks) {
            clock.time.text = time;
            clock.date.text = date;
        }
    }

    _placeAll() {
        for (const clock of this._clocks ?? [])
            this._place(clock);
    }

    _place(clock) {
        const layout = Main.layoutManager;
        const monitor = layout.monitors[clock.monitorIndex];
        if (!monitor)
            return;
        const workArea = layout.getWorkAreaForMonitor(clock.monitorIndex);
        const {width, height} = clock.box;
        const monitorBottom = monitor.y + monitor.height;
        const workAreaBottom = workArea.y + workArea.height;
        const band = monitorBottom - workAreaBottom;
        const y = band >= height
            ? workAreaBottom + Math.floor((band - height) / 2)
            : monitorBottom - height - MARGIN;
        clock.box.set_position(monitor.x + monitor.width - width - MARGIN, y);
    }
}
