/*
 * TaskDelegate.qml - Visual representation of a single task item
 *
 * Features:
 * - Drag & drop reordering via drag handle
 * - Visual feedback during drag operations
 * - Context menu for task actions (priority, due date, delete)
 * - Priority indicator with color coding
 * - Due date display with overdue highlighting
 * - Checkbox for completion toggle
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

PlasmaComponents.ItemDelegate {
    id: delegate

    width: ListView.view ? ListView.view.width : 200
    height: 60
    z: isDragging ? 100 : 0  // Elevate during drag

    // =========================================================================
    // REQUIRED MODEL PROPERTIES
    // =========================================================================

    required property int index
    required property string title
    required property bool done
    required property int priority
    required property string category
    required property string dueDate

    // =========================================================================
    // SIGNALS
    // =========================================================================

    signal taskChanged()                          // Emitted when task data is modified
    signal taskDeleted()                          // Emitted when task should be removed
    signal dropTargetChanged(int targetIndex)     // Emitted during drag with current target
    signal dragStarted(int sourceIndex)           // Emitted when drag begins
    signal dropping()                             // Emitted just before drop (triggers reset)
    signal dropped()                              // Emitted after drop completes

    // =========================================================================
    // DRAG & DROP STATE
    // =========================================================================

    property bool isDragging: false
    property alias dragActive: delegate.isDragging
    property real dragOffsetY: 0
    property bool animateTransform: true

    // Grid cell size for snap calculations (item height + spacing)
    readonly property real gridSize: height + (ListView.view ? ListView.view.spacing : 2)

    // =========================================================================
    // DRAG & DROP - SPACE MAKING LOGIC
    // =========================================================================

    /**
     * Determines if this item should visually shift to make space
     * for the currently dragged item.
     */
    readonly property bool shouldMakeSpace: {
        const listView = ListView.view;
        if (!listView || !listView.currentDragActive) return false;
        if (isDragging) return false;  // Dragged item doesn't shift

        const dropTarget = listView.dropTargetIndex;
        const dragSource = listView.dragSourceIndex;

        if (dropTarget < 0 || dragSource < 0) return false;
        if (dropTarget === dragSource) return false;

        if (dragSource < dropTarget) {
            // Dragging downward: items between source+1 and target shift up
            return index > dragSource && index <= dropTarget;
        } else {
            // Dragging upward: items between target and source-1 shift down
            return index >= dropTarget && index < dragSource;
        }
    }

    /**
     * Direction multiplier for space-making offset.
     * -1 = shift up (when dragging down), +1 = shift down (when dragging up)
     */
    readonly property int spaceDirection: {
        const listView = ListView.view;
        if (!listView) return 1;
        return listView.dragSourceIndex < listView.dropTargetIndex ? -1 : 1;
    }

    // =========================================================================
    // VISUAL TRANSFORM FOR DRAG & DROP
    // =========================================================================

    transform: Translate {
        y: {
            if (isDragging) return dragOffsetY;
            if (shouldMakeSpace) return gridSize * spaceDirection;
            return 0;
        }

        Behavior on y {
            enabled: !isDragging && delegate.animateTransform

            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }
    }

    // Listen for global reset signal from ListView
    Connections {
        target: delegate.ListView.view

        function onResetAllTransforms() {
            delegate.animateTransform = false;
            delegate.dragOffsetY = 0;
        }
    }

    // =========================================================================
    // HELPER FUNCTIONS
    // =========================================================================

    /**
     * Calculates the snapped grid index for a given Y position.
     * Used to determine drop target during drag.
     */
    function getSnappedIndex(yPos) {
        const listView = ListView.view;
        if (!listView) return index;

        return Math.max(0, Math.min(
            Math.round(yPos / gridSize),
            listView.count - 1
        ));
    }

    /**
     * Returns the color for a priority level.
     * @param {int} p - Priority (0=Low, 1=Medium, 2=High)
     */
    function getPriorityColor(p) {
        switch (p) {
            case 2:
                return "#ed2424";
            case 1:
                return "#f57900";
            default:
                return "#729fcf";
        }
    }

    /**
     * Formats the due date for display using locale settings.
     */
    function getDueDateLabel() {
        if (!dueDate) return "";
        const date = new Date(dueDate);
        return date.toLocaleDateString(Qt.locale(), Locale.ShortFormat);
    }

    /**
     * Checks if the task is overdue (past due date and not completed).
     */
    function isOverdue() {
        if (!dueDate || done) return false;
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        return new Date(dueDate) < today;
    }

    // =========================================================================
    // CONTENT LAYOUT
    // =========================================================================

    contentItem: Item {
        anchors.fill: parent

        RowLayout {
            id: contentRow
            spacing: 8
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            // -----------------------------------------------------------------
            // Drag Handle
            // -----------------------------------------------------------------
            Rectangle {
                width: 24
                height: 40
                color: "transparent"
                Layout.alignment: Qt.AlignVCenter

                Text {
                    anchors.centerIn: parent
                    text: "⋮⋮"
                    font.pixelSize: 16
                    color: dragArea.containsMouse || isDragging
                        ? PlasmaCore.Theme.highlightColor
                        : PlasmaCore.Theme.disabledTextColor
                }

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: isDragging ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                    preventStealing: true  // Prevent ListView from stealing events

                    property real startMouseY: 0
                    property int startIndex: -1

                    onPressed: (mouse) => {
                        startMouseY = mapToItem(delegate.ListView.view, 0, mouse.y).y;
                        startIndex = delegate.index;
                        delegate.isDragging = true;
                        delegate.dragStarted(delegate.index);
                    }

                    onPositionChanged: (mouse) => {
                        if (!isDragging) return;

                        const currentY = mapToItem(delegate.ListView.view, 0, mouse.y).y;
                        delegate.dragOffsetY = currentY - startMouseY;

                        // Calculate and broadcast current drop target
                        const originalY = delegate.index * delegate.gridSize;
                        const targetIndex = delegate.getSnappedIndex(originalY + delegate.dragOffsetY);
                        delegate.dropTargetChanged(targetIndex);
                    }

                    onReleased: {
                        if (!isDragging) return;

                        const listView = delegate.ListView.view;
                        const originalY = delegate.index * delegate.gridSize;
                        const currentY = originalY + delegate.dragOffsetY;
                        const targetIndex = delegate.getSnappedIndex(currentY);
                        const shouldMove = startIndex !== targetIndex;

                        // Signal drop (resets ALL items instantly via ListView)
                        delegate.dropping();

                        // Reset local state
                        delegate.isDragging = false;
                        delegate.dropTargetChanged(-1);

                        if (shouldMove) {
                            listView.model.moveTask(startIndex, targetIndex);
                        }

                        // Re-enable animations after short delay
                        dropTimer.start();
                        startIndex = -1;
                    }

                    onCanceled: {
                        delegate.dragOffsetY = 0;
                        delegate.isDragging = false;
                        delegate.dropTargetChanged(-1);
                    }
                }
            }

            // Timer to re-enable transform animations after drop
            Timer {
                id: dropTimer
                interval: 50
                onTriggered: delegate.animateTransform = true
            }

            // -----------------------------------------------------------------
            // Completion Checkbox
            // -----------------------------------------------------------------
            PlasmaComponents.CheckBox {
                checked: delegate.done

                onToggled: {
                    delegate.ListView.view.model.setProperty(delegate.index, "done", checked);
                    delegate.taskChanged();
                }
            }

            // -----------------------------------------------------------------
            // Task Content (Title + Due Date)
            // -----------------------------------------------------------------
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 0

                RowLayout {
                    spacing: 4
                    Layout.fillWidth: true

                    // Priority indicator dot
                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: delegate.getPriorityColor(delegate.priority)
                        Layout.alignment: Qt.AlignVCenter
                    }

                    // Task title
                    PlasmaComponents.Label {
                        text: delegate.title
                        font.strikeout: delegate.done
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        opacity: delegate.done ? 0.6 : 1.0
                        Layout.alignment: Qt.AlignVCenter
                    }
                }

                // Due date row
                RowLayout {
                    visible: delegate.dueDate !== ""
                    Layout.leftMargin: 12
                    spacing: 8

                    PlasmaComponents.Label {
                        text: "📅 " + delegate.getDueDateLabel()
                        font.pixelSize: 10
                        font.bold: delegate.isOverdue()
                        color: delegate.isOverdue() ? "#ed2424" : PlasmaCore.Theme.disabledTextColor
                    }
                }
            }

            // -----------------------------------------------------------------
            // Edit Button (opens context menu)
            // -----------------------------------------------------------------
            PlasmaComponents.Button {
                icon.name: "entry-edit-symbolic"
                flat: true
                onClicked: contextMenu.open()
            }
        }
    }

    // =========================================================================
    // BACKGROUND
    // =========================================================================

    background: Rectangle {
        color: isDragging ? PlasmaCore.Theme.highlightColor :
            (delegate.hovered ? PlasmaCore.Theme.backgroundColor : "transparent")
        radius: 4
        opacity: isDragging ? 0.8 : 1.0

        layer.enabled: isDragging
        layer.effect: null  // Could add DropShadow if available
    }

    // =========================================================================
    // RIGHT-CLICK CONTEXT MENU TRIGGER
    // =========================================================================

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton

        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                contextMenu.popup();
            }
        }
    }

    // =========================================================================
    // CONTEXT MENU
    // =========================================================================

    Controls.Menu {
        id: contextMenu
        popupType: Controls.Popup.Window

        // Due Date Submenu
        Controls.Menu {
            title: i18n("Due date")
            icon.name: "appointment-new"
            popupType: Controls.Popup.Window

            Controls.MenuItem {
                text: i18n("Today")
                onTriggered: {
                    let d = new Date();
                    delegate.ListView.view.model.setProperty(
                        delegate.index, "dueDate", d.toISOString().split('T')[0]
                    );
                    delegate.taskChanged();
                }
            }

            Controls.MenuItem {
                text: i18n("Tomorrow")
                onTriggered: {
                    let d = new Date();
                    d.setDate(d.getDate() + 1);
                    delegate.ListView.view.model.setProperty(
                        delegate.index, "dueDate", d.toISOString().split('T')[0]
                    );
                    delegate.taskChanged();
                }
            }

            Controls.MenuItem {
                text: i18n("Custom date")
                onTriggered: datePickerDialog.open()
            }

            Controls.MenuSeparator {}

            Controls.MenuItem {
                text: i18n("Delete date")
                onTriggered: {
                    delegate.ListView.view.model.setProperty(delegate.index, "dueDate", "");
                    delegate.taskChanged();
                }
            }
        }

        Controls.MenuSeparator {}

        // Priority Submenu
        Controls.Menu {
            title: i18n("Priority")
            icon.name: "flag"
            popupType: Controls.Popup.Window

            Controls.MenuItem {
                text: i18n("High")
                onTriggered: {
                    delegate.ListView.view.model.setProperty(delegate.index, "priority", 2);
                    delegate.taskChanged();
                }
            }

            Controls.MenuItem {
                text: i18n("Medium")
                onTriggered: {
                    delegate.ListView.view.model.setProperty(delegate.index, "priority", 1);
                    delegate.taskChanged();
                }
            }

            Controls.MenuItem {
                text: i18n("Low")
                onTriggered: {
                    delegate.ListView.view.model.setProperty(delegate.index, "priority", 0);
                    delegate.taskChanged();
                }
            }
        }

        Controls.MenuSeparator {}

        // Rename Action
        Controls.MenuItem {
            text: i18n("Rename")
            icon.name: "edit-rename"
            onTriggered: renameDialog.open()
        }

        Controls.MenuSeparator {}

        // Delete Action
        Controls.MenuItem {
            text: i18n("Delete")
            icon.name: "edit-delete"
            onTriggered: delegate.taskDeleted()
        }
    }

    // =========================================================================
    // DATE PICKER DIALOG
    // =========================================================================

    Controls.Dialog {
        id: datePickerDialog
        title: i18n("Choose date")
        modal: true
        anchors.centerIn: parent

        contentItem: ColumnLayout {
            spacing: 12

            RowLayout {
                spacing: 8
                PlasmaComponents.Label {
                    text: i18n("Day:")
                }
                PlasmaComponents.SpinBox {
                    id: daySpinBox
                    from: 1
                    to: 31
                    value: new Date().getDate()
                }
            }

            RowLayout {
                spacing: 8
                PlasmaComponents.Label {
                    text: i18n("Month:")
                }
                PlasmaComponents.SpinBox {
                    id: monthSpinBox
                    from: 1
                    to: 12
                    value: new Date().getMonth() + 1
                }
            }

            RowLayout {
                spacing: 8
                PlasmaComponents.Label {
                    text: i18n("Year:")
                }
                PlasmaComponents.SpinBox {
                    id: yearSpinBox
                    from: 2020
                    to: 2099
                    value: new Date().getFullYear()
                }
            }
        }

        standardButtons: Controls.Dialog.Ok | Controls.Dialog.Cancel

        onAccepted: {
            const day = String(daySpinBox.value).padStart(2, '0');
            const month = String(monthSpinBox.value).padStart(2, '0');
            const year = yearSpinBox.value;

            delegate.ListView.view.model.setProperty(
                delegate.index, "dueDate", `${year}-${month}-${day}`
            );
            delegate.taskChanged();
        }
    }

    // =========================================================================
    // RENAME DIALOG
    // =========================================================================

    Controls.Dialog {
        id: renameDialog
        title: i18n("Rename task")
        modal: true
        anchors.centerIn: parent

        contentItem: ColumnLayout {
            spacing: 8

            PlasmaComponents.Label {
                text: i18n("Title:")
            }

            PlasmaComponents.TextField {
                id: renameInput
                Layout.fillWidth: true
                selectByMouse: true

                onAccepted: renameDialog.accept()
            }
        }

        standardButtons: Controls.Dialog.Ok | Controls.Dialog.Cancel

        onOpened: {
            renameInput.text = delegate.title;
            renameInput.forceActiveFocus();
            renameInput.selectAll();
        }

        onAccepted: {
            const trimmed = renameInput.text.trim();
            if (trimmed === "") return;
            delegate.ListView.view.model.setProperty(delegate.index, "title", trimmed);
            delegate.taskChanged();
        }
    }
}
