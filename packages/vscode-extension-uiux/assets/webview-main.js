/**
 * VS Code Webview Main Script Template
 * Use as a starting point for webview JavaScript.
 * Copy this file to your extension's media/ folder.
 */

// Acquire VS Code API (can only be called once)
const vscode = acquireVsCodeApi();

// State management
let state = vscode.getState() || {};

/**
 * Save state to VS Code (persists across webview visibility changes)
 */
function saveState(newState) {
  state = { ...state, ...newState };
  vscode.setState(state);
}

/**
 * Send message to extension
 */
function sendMessage(type, payload) {
  vscode.postMessage({ type, payload });
}

/**
 * Handle messages from extension
 */
window.addEventListener('message', event => {
  const message = event.data;

  // Validate message structure
  if (!message || typeof message.type !== 'string') {
    console.warn('Invalid message received:', message);
    return;
  }

  switch (message.type) {
    case 'init':
      // Initialize with data from extension
      handleInit(message.data);
      break;

    case 'update':
      // Update UI with new data
      handleUpdate(message.data);
      break;

    case 'error':
      // Show error message
      showError(message.text);
      break;

    default:
      console.warn('Unknown message type:', message.type);
  }
});

/**
 * Handle initialization data from extension
 */
function handleInit(data) {
  if (data) {
    saveState({ data });
    renderUI(data);
  }
}

/**
 * Handle data updates from extension
 */
function handleUpdate(data) {
  saveState({ data });
  renderUI(data);
}

/**
 * Render the main UI
 */
function renderUI(data) {
  const app = document.getElementById('app');
  if (!app) return;

  // Example: Render a list
  if (data && data.items) {
    app.innerHTML = `
      <div class="toolbar flex justify-between items-center mb-2">
        <h2>Items (${data.items.length})</h2>
        <button id="refresh-btn" class="icon-btn" title="Refresh">
          <span class="codicon codicon-refresh"></span>
        </button>
      </div>
      <ul class="list" role="listbox" aria-label="Items list">
        ${data.items.map((item, index) => `
          <li class="list-item"
              role="option"
              tabindex="${index === 0 ? 0 : -1}"
              data-id="${escapeHtml(item.id)}">
            <span class="codicon codicon-${item.icon || 'file'}"></span>
            <span class="item-label">${escapeHtml(item.label)}</span>
            ${item.description ? `<span class="text-muted">${escapeHtml(item.description)}</span>` : ''}
          </li>
        `).join('')}
      </ul>
    `;

    // Attach event listeners
    attachListeners();
  }
}

/**
 * Attach event listeners to dynamic elements
 */
function attachListeners() {
  // Refresh button
  const refreshBtn = document.getElementById('refresh-btn');
  if (refreshBtn) {
    refreshBtn.addEventListener('click', () => {
      sendMessage('refresh');
    });
  }

  // List items
  const listItems = document.querySelectorAll('.list-item');
  listItems.forEach(item => {
    item.addEventListener('click', () => {
      const id = item.dataset.id;
      selectItem(id);
      sendMessage('selectItem', { id });
    });

    // Keyboard navigation
    item.addEventListener('keydown', (e) => {
      handleListKeydown(e, item);
    });
  });
}

/**
 * Handle keyboard navigation in lists
 */
function handleListKeydown(event, currentItem) {
  const list = currentItem.closest('.list');
  const items = Array.from(list.querySelectorAll('.list-item'));
  const currentIndex = items.indexOf(currentItem);

  let nextIndex = currentIndex;

  switch (event.key) {
    case 'ArrowDown':
      event.preventDefault();
      nextIndex = Math.min(currentIndex + 1, items.length - 1);
      break;
    case 'ArrowUp':
      event.preventDefault();
      nextIndex = Math.max(currentIndex - 1, 0);
      break;
    case 'Home':
      event.preventDefault();
      nextIndex = 0;
      break;
    case 'End':
      event.preventDefault();
      nextIndex = items.length - 1;
      break;
    case 'Enter':
    case ' ':
      event.preventDefault();
      const id = currentItem.dataset.id;
      selectItem(id);
      sendMessage('selectItem', { id });
      return;
    default:
      return;
  }

  if (nextIndex !== currentIndex) {
    items[currentIndex].tabIndex = -1;
    items[nextIndex].tabIndex = 0;
    items[nextIndex].focus();
  }
}

/**
 * Select an item in the list
 */
function selectItem(id) {
  const items = document.querySelectorAll('.list-item');
  items.forEach(item => {
    item.classList.toggle('selected', item.dataset.id === id);
    item.setAttribute('aria-selected', item.dataset.id === id);
  });

  saveState({ selectedId: id });
}

/**
 * Show error message to user
 */
function showError(text) {
  const app = document.getElementById('app');
  if (!app) return;

  // Create or update error element
  let errorEl = document.getElementById('error-message');
  if (!errorEl) {
    errorEl = document.createElement('div');
    errorEl.id = 'error-message';
    errorEl.className = 'card status-error';
    errorEl.setAttribute('role', 'alert');
    app.prepend(errorEl);
  }

  errorEl.innerHTML = `
    <span class="codicon codicon-error"></span>
    <span>${escapeHtml(text)}</span>
    <button class="icon-btn" onclick="this.parentElement.remove()" aria-label="Dismiss">
      <span class="codicon codicon-close"></span>
    </button>
  `;
}

/**
 * Escape HTML to prevent XSS
 */
function escapeHtml(text) {
  if (!text) return '';
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

/**
 * Announce message to screen readers
 */
function announce(message, priority = 'polite') {
  let announcer = document.getElementById('sr-announcer');
  if (!announcer) {
    announcer = document.createElement('div');
    announcer.id = 'sr-announcer';
    announcer.className = 'sr-only';
    announcer.setAttribute('aria-live', priority);
    announcer.setAttribute('aria-atomic', 'true');
    document.body.appendChild(announcer);
  }

  announcer.textContent = message;
}

// Initialize on DOM ready
document.addEventListener('DOMContentLoaded', () => {
  // Restore state if available
  if (state.data) {
    renderUI(state.data);
  }

  // Restore selection
  if (state.selectedId) {
    selectItem(state.selectedId);
  }

  // Tell extension we're ready
  sendMessage('ready');
});
