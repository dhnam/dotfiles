// 스크린샷 화면(Win+Shift+S, Print)의 조작판과 닫기 버튼을 주 모니터 대신 마우스가 있는 모니터에 띄운다.
// "화면" 모드에서 처음 골라지는 모니터와 "영역" 모드의 상자도 마우스가 있는 모니터로 옮긴다.
//
// GNOME은 조작판을 담은 _primaryMonitorBin을 Layout.MonitorConstraint({primary: true})로 주 모니터에
// 붙여 둔다. 스크린샷 화면이 닫힌 상태에서 열리기 직전에 그 제약의 모니터 번호를 바꾼다.
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as Layout from 'resource:///org/gnome/shell/ui/layout.js';
import * as Screenshot from 'resource:///org/gnome/shell/ui/screenshot.js';
import {Extension, InjectionManager} from 'resource:///org/gnome/shell/extensions/extension.js';

export default class ScreenshotFollowsPointer extends Extension {
    enable() {
        this._injectionManager = new InjectionManager();
        this._injectionManager.overrideMethod(Screenshot.ScreenshotUI.prototype, 'open',
            original => function (...args) {
                if (!this.visible)
                    moveToPointerMonitor(this);
                return original.apply(this, args);
            });
    }

    disable() {
        this._injectionManager.clear();
        this._injectionManager = null;
        const constraint = monitorConstraint(Main.screenshotUI);
        if (constraint)
            constraint.primary = true;
    }
}

function monitorConstraint(ui) {
    return ui?._primaryMonitorBin?.get_constraints()
        .find(c => c instanceof Layout.MonitorConstraint) ?? null;
}

function moveToPointerMonitor(ui) {
    const index = global.display.get_current_monitor();
    if (index < 0)
        return;
    const constraint = monitorConstraint(ui);
    if (constraint && constraint.index !== index)
        constraint.index = index;
    // 화면 고르기 버튼은 하나를 켜면 나머지가 꺼진다 (screenshot.js의 notify::checked)
    const selector = ui._screenSelectors?.[index];
    if (selector)
        selector.checked = true;
    moveAreaToMonitor(ui._areaSelector, Main.layoutManager.monitors[index]);
}

// 영역 상자: 지난번 상자가 이 모니터에 있으면 그대로 두고(GNOME의 "마지막 영역 기억"),
// 다른 모니터에 있으면 GNOME 기본값처럼 이 모니터 가운데 1/4 크기로 놓는다.
function moveAreaToMonitor(area, monitor) {
    if (!area || !monitor)
        return;
    const [x, y, w, h] = area.getGeometry();
    const cx = x + w / 2;
    const cy = y + h / 2;
    if (cx >= monitor.x && cx < monitor.x + monitor.width &&
        cy >= monitor.y && cy < monitor.y + monitor.height)
        return;
    area._startX = monitor.x + Math.floor(monitor.width * 3 / 8);
    area._startY = monitor.y + Math.floor(monitor.height * 3 / 8);
    area._lastX = monitor.x + Math.floor(monitor.width * 5 / 8) - 1;
    area._lastY = monitor.y + Math.floor(monitor.height * 5 / 8) - 1;
    area._updateSelectionRect();
}
