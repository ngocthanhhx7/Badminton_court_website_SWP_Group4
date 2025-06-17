// Chat functionality
function showChatbox() {
    const chatbox = document.getElementById('chatbox-container');
    if (chatbox.style.display === 'none' || chatbox.style.display === '') {
        chatbox.style.display = 'block';
    } else {
        chatbox.style.display = 'none';
    }
}

function sendMessage() {
    const messageInput = document.getElementById('message-input');
    const message = messageInput.value.trim();
    
    if (message === '') {
        return;
    }
    
    // Add user message to chat
    addMessageToChat('user', message);
    messageInput.value = '';
    
    // Show loading indicator
    addMessageToChat('assistant', 'Đang xử lý...', true);
    
    // Send message to server
    fetch('ChatGPTServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'message=' + encodeURIComponent(message)
    })
    .then(response => response.json())
    .then(data => {
        // Remove loading message
        removeLoadingMessage();
        
        if (data.error) {
            addMessageToChat('assistant', 'Lỗi: ' + data.error);
        } else if (data.choices && data.choices.length > 0) {
            const assistantMessage = data.choices[0].message.content;
            addMessageToChat('assistant', assistantMessage);
        } else {
            addMessageToChat('assistant', 'Không thể xử lý tin nhắn. Vui lòng thử lại.');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        removeLoadingMessage();
        addMessageToChat('assistant', 'Lỗi kết nối. Vui lòng thử lại.');
    });
}

function addMessageToChat(role, message, isLoading = false) {
    const chatMessages = document.getElementById('chat-messages');
    const messageDiv = document.createElement('div');
    messageDiv.className = 'message ' + role + '-message';
    
    if (isLoading) {
        messageDiv.id = 'loading-message';
        messageDiv.innerHTML = '<div class="loading-dots"><span></span><span></span><span></span></div>';
    } else {
        messageDiv.textContent = message;
    }
    
    chatMessages.appendChild(messageDiv);
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

function removeLoadingMessage() {
    const loadingMessage = document.getElementById('loading-message');
    if (loadingMessage) {
        loadingMessage.remove();
    }
}

// Handle Enter key press
document.addEventListener('DOMContentLoaded', function() {
    const messageInput = document.getElementById('message-input');
    if (messageInput) {
        messageInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });
    }
}); 