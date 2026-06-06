
/*
 * main.qml - Main entry point for the ToDo List Plasma Applet
 *
 * This file defines the root PlasmoidItem and the main UI layout including:
 * - Header with title
 * - Input field for new tasks
 * - ListView with drag & drop support
 * - Footer with task count and clear button
 */

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

PlasmoidItem {
    id: root

    // =========================================================================
    // DATA MODEL
    // =========================================================================

    TaskModel {
        id: taskModel
    }

    // =========================================================================
    // MAIN UI
    // =========================================================================

    fullRepresentation: ColumnLayout {
        spacing: 4
        Layout.minimumWidth: 300
        Layout.minimumHeight: 400

        // ---------------------------------------------------------------------
        // Header
        // ---------------------------------------------------------------------
        PlasmaExtras.Heading {
            level: 3
            text: i18n("My Tasks")
            Layout.margins: 4
        }

        // ---------------------------------------------------------------------
        // Task Input Row
        // ---------------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 4

            PlasmaComponents.TextField {
                id: newTaskInput
                Layout.fillWidth: true
                placeholderText: i18n("New task...")

                onAccepted: {
                    taskModel.add(text);
                    text = "";
                }
            }

            PlasmaComponents.Button {
                icon.name: "list-add-symbolic"

                onClicked: {
                    taskModel.add(newTaskInput.text);
                    newTaskInput.text = "";
                }
            }
        }

        // ---------------------------------------------------------------------
        // Task List with Drag & Drop Support
        // ---------------------------------------------------------------------
        ListView {
            id: taskListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: taskModel
            spacing: 2

            // Disable scrolling while dragging to prevent conflicts
            interactive: !currentDragActive

            // Drag & Drop state properties
            property bool currentDragActive: false
            property int dropTargetIndex: -1
            property int dragSourceIndex: -1
            property bool isDropping: false

            // Signal to reset all delegate transforms simultaneously
            signal resetAllTransforms()

            // Animation for displaced items (disabled during drop to prevent jitter)
            displaced: Transition {
                enabled: !taskListView.isDropping

                NumberAnimation {
                    properties: "y"
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }

            delegate: TaskDelegate {
                // Task data change handlers
                onTaskChanged: taskModel.save()
                onTaskDeleted: taskModel.removeTask(index)

                // Drag & Drop event handlers
                onDragActiveChanged: taskListView.currentDragActive = dragActive
                onDragStarted: (sourceIdx) => taskListView.dragSourceIndex = sourceIdx
                onDropTargetChanged: (targetIdx) => taskListView.dropTargetIndex = targetIdx

                onDropping: {
                    taskListView.isDropping = true;
                    taskListView.resetAllTransforms();
                    reEnableAnimationTimer.start();
                }

                onDropped: taskListView.isDropping = false
            }

            // Timer to re-enable displaced animation after transform reset
            // Uses single frame delay (~16ms at 60fps) for smooth transition
            Timer {
                id: reEnableAnimationTimer
                interval: 16
                onTriggered: taskListView.isDropping = false
            }
        }

        // ---------------------------------------------------------------------
        // Footer
        // ---------------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 4

            PlasmaComponents.Label {
                text: i18n("%1 tasks", taskModel.count)
                Layout.fillWidth: true
            }

            PlasmaComponents.Button {
                text: i18n("Delete completed")
                icon.name: "edit-clear-all"
                onClicked: taskModel.clearDone()
            }
        }
    }
}
