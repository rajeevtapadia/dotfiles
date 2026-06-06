/*
 * TaskModel.qml - Data model for task storage and persistence
 *
 * Extends ListModel to provide:
 * - JSON-based persistence via Plasmoid configuration
 * - CRUD operations for tasks (Create, Read, Update, Delete)
 * - Task reordering support for drag & drop
 *
 * Task Schema:
 * {
 *   title: string,      - Task description
 *   done: boolean,      - Completion status
 *   priority: int,      - Priority level (0=Low, 1=Medium, 2=High)
 *   category: string,   - Category label
 *   createdAt: string,  - ISO timestamp of creation
 *   dueDate: string     - Due date in YYYY-MM-DD format (empty if not set)
 * }
 */

import QtQuick
import org.kde.plasma.plasmoid

ListModel {
    id: taskModel

    // =========================================================================
    // INITIALIZATION
    // =========================================================================

    Component.onCompleted: load()

    // =========================================================================
    // PERSISTENCE
    // =========================================================================

    /**
     * Loads tasks from persistent storage (Plasmoid configuration).
     * Parses JSON string and populates the model.
     */
    function load() {
        if (plasmoid.configuration.tasksJson) {
            try {
                const data = JSON.parse(plasmoid.configuration.tasksJson);
                clear();
                data.forEach(item => append(item));
            } catch (e) {
                console.error("Failed to load tasks:", e);
            }
        }
    }

    /**
     * Persists current tasks to Plasmoid configuration as JSON string.
     * Called automatically after any model modification.
     */
    function save() {
        const data = [];
        for (let i = 0; i < count; i++) {
            data.push(get(i));
        }
        plasmoid.configuration.tasksJson = JSON.stringify(data);
    }

    // =========================================================================
    // CRUD OPERATIONS
    // =========================================================================

    /**
     * Updates a single property of a task at the given index.
     * Automatically triggers save after modification.
     *
     * @param {int} index - Task index in the model
     * @param {string} property - Property name to update
     * @param {any} value - New value for the property
     */
    function setProperty(index, property, value) {
        if (index >= 0 && index < count) {
            set(index, { [property]: value });
            save();
        }
    }

    /**
     * Creates a new task and inserts it at the top of the list.
     * Ignores empty or whitespace-only titles.
     *
     * @param {string} title - Task title/description
     */
    function add(title) {
        if (title.trim() === "") return;

        insert(0, {
            title: title,
            done: false,
            priority: 1,  // Default to medium priority
            category: "Private",
            createdAt: new Date().toISOString(),
            dueDate: ""
        });
        save();
    }

    /**
     * Removes a task at the specified index.
     *
     * @param {int} index - Task index to remove
     */
    function removeTask(index) {
        remove(index);
        save();
    }

    /**
     * Moves a task from one position to another.
     * Used for drag & drop reordering.
     *
     * @param {int} from - Source index
     * @param {int} to - Destination index
     */
    function moveTask(from, to) {
        if (from === to) return;
        move(from, to, 1);
        save();
    }

    /**
     * Removes all tasks marked as done.
     * Iterates in reverse to maintain correct indices during removal.
     */
    function clearDone() {
        for (let i = count - 1; i >= 0; i--) {
            if (get(i).done) {
                remove(i);
            }
        }
        save();
    }
}
