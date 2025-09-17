class TaskManager {
    constructor() {
        this.apiUrl = '/api/tasks';
        this.taskForm = document.getElementById('taskForm');
        this.tasksList = document.getElementById('tasksList');
        
        this.init();
    }

    init() {
        this.taskForm.addEventListener('submit', this.handleSubmit.bind(this));
        this.loadTasks();
    }

    async handleSubmit(e) {
        e.preventDefault();
        
        const title = document.getElementById('taskTitle').value.trim();
        const description = document.getElementById('taskDescription').value.trim();
        
        if (!title) return;

        try {
            await this.createTask({ title, description });
            this.taskForm.reset();
            this.loadTasks();
        } catch (error) {
            console.error('Error creating task:', error);
            alert('Failed to create task');
        }
    }

    async loadTasks() {
        try {
            this.tasksList.innerHTML = '<div class="loading">Loading tasks...</div>';
            const tasks = await this.fetchTasks();
            this.renderTasks(tasks);
        } catch (error) {
            console.error('Error loading tasks:', error);
            this.tasksList.innerHTML = '<div class="loading">Failed to load tasks</div>';
        }
    }

    async fetchTasks() {
        const response = await fetch(this.apiUrl);
        if (!response.ok) throw new Error('Failed to fetch tasks');
        return response.json();
    }

    async createTask(task) {
        const response = await fetch(this.apiUrl, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(task)
        });
        if (!response.ok) throw new Error('Failed to create task');
        return response.json();
    }

    async updateTask(id, updates) {
        const response = await fetch(`${this.apiUrl}/${id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(updates)
        });
        if (!response.ok) throw new Error('Failed to update task');
        return response.json();
    }

    async deleteTask(id) {
        const response = await fetch(`${this.apiUrl}/${id}`, {
            method: 'DELETE'
        });
        if (!response.ok) throw new Error('Failed to delete task');
    }

    renderTasks(tasks) {
        if (tasks.length === 0) {
            this.tasksList.innerHTML = '<div class="loading">No tasks yet. Add one above!</div>';
            return;
        }

        this.tasksList.innerHTML = tasks.map(task => `
            <div class="task-item ${task.completed ? 'completed' : ''}">
                <div class="task-content">
                    <h3>${this.escapeHtml(task.title)}</h3>
                    ${task.description ? `<p>${this.escapeHtml(task.description)}</p>` : ''}
                </div>
                <div class="task-actions">
                    <button class="btn-complete" onclick="taskManager.toggleComplete(${task.id}, ${!task.completed})">
                        ${task.completed ? 'Undo' : 'Complete'}
                    </button>
                    <button class="btn-delete" onclick="taskManager.handleDelete(${task.id})">
                        Delete
                    </button>
                </div>
            </div>
        `).join('');
    }

    async toggleComplete(id, completed) {
        try {
            const tasks = await this.fetchTasks();
            const task = tasks.find(t => t.id === id);
            if (!task) return;

            await this.updateTask(id, { ...task, completed });
            this.loadTasks();
        } catch (error) {
            console.error('Error updating task:', error);
            alert('Failed to update task');
        }
    }

    async handleDelete(id) {
        if (!confirm('Are you sure you want to delete this task?')) return;

        try {
            await this.deleteTask(id);
            this.loadTasks();
        } catch (error) {
            console.error('Error deleting task:', error);
            alert('Failed to delete task');
        }
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Initialize the app
const taskManager = new TaskManager();