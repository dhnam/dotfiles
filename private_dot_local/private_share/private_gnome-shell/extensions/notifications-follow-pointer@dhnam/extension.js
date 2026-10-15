// 알림 배너를 주 모니터 대신 마우스가 있는 모니터에 띄운다.
//
// GNOME은 알림 영역(Main.messageTray)을 Layout.MonitorConstraint({primary: true})로 주 모니터에
// 붙여 둔다. 새 알림을 띄우기 직전(queue-changed)에 그 제약의 모니터 번호를 마우스가 있는 모니터로 바꾼다.
// 이미 떠 있는 알림은 옮기지 않는다. 위치(모서리)는 Notification Banner 확장이 맡는다.
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as Layout from 'resource:///org/gnome/shell/ui/layout.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

export default class NotificationsFollowPointer extends Extension {
    enable() {
        const tray = Main.messageTray;
        this._constraint = tray.get_constraints()
            .find(c => c instanceof Layout.MonitorConstraint) ?? null;
        if (!this._constraint) {
            console.warn(`${this.uuid}: message tray has no MonitorConstraint, doing nothing`);
            return;
        }
        tray.connectObject('queue-changed', () => this._followPointer(), this);
    }

    _followPointer() {
        // queue-changed는 알림이 떠 있는 동안 새 알림이 쌓일 때도 오므로, 떠 있는 배너가 없을 때만 옮긴다
        if (Main.messageTray._banner)
            return;
        const index = global.display.get_current_monitor();
        if (index >= 0 && this._constraint.index !== index)
            this._constraint.index = index;
    }

    disable() {
        Main.messageTray.disconnectObject(this);
        if (this._constraint)
            this._constraint.primary = true;
        this._constraint = null;
    }
}
