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
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        // Remove loading message
        removeLoadingMessage();
        
        if (data.error) {
            // Handle different error types
            let errorMessage = 'Lỗi: ' + data.error;
            
            if (data.error_type === 'quota_exceeded') {
                errorMessage = '⚠️ Hạn mức API đã hết. Vui lòng thử lại sau hoặc liên hệ hỗ trợ.';
                if (data.suggestion) {
                    errorMessage += '\n\n💡 Gợi ý: ' + data.suggestion;
                }
            } else if (data.error_type === 'unauthorized') {
                errorMessage = '🔐 Lỗi xác thực API. Vui lòng liên hệ hỗ trợ.';
                if (data.suggestion) {
                    errorMessage += '\n\n💡 Gợi ý: ' + data.suggestion;
                }
            } else if (data.error_type === 'bad_request') {
                errorMessage = '❌ Yêu cầu không hợp lệ. Vui lòng kiểm tra lại tin nhắn.';
                if (data.suggestion) {
                    errorMessage += '\n\n💡 Gợi ý: ' + data.suggestion;
                }
            } else if (data.error_type === 'server_error') {
                errorMessage = '🔧 Lỗi máy chủ. Vui lòng thử lại sau.';
                if (data.suggestion) {
                    errorMessage += '\n\n💡 Gợi ý: ' + data.suggestion;
                }
            } else if (data.error_type === 'configuration_error') {
                errorMessage = '⚙️ Lỗi cấu hình hệ thống. Vui lòng liên hệ hỗ trợ.';
                if (data.suggestion) {
                    errorMessage += '\n\n💡 Gợi ý: ' + data.suggestion;
                }
            } else if (data.error_type === 'validation_error') {
                errorMessage = '📝 ' + data.error;
                if (data.suggestion) {
                    errorMessage += '\n\n💡 Gợi ý: ' + data.suggestion;
                }
            } else if (data.error_type === 'internal_error') {
                errorMessage = '💥 Lỗi hệ thống. Vui lòng thử lại sau.';
                if (data.suggestion) {
                    errorMessage += '\n\n💡 Gợi ý: ' + data.suggestion;
                }
            }
            
            addMessageToChat('assistant', errorMessage);
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
        
        let errorMessage = 'Lỗi kết nối. Vui lòng thử lại.';
        
        if (error.message.includes('HTTP error! status: 503')) {
            errorMessage = '🔧 Dịch vụ tạm thời không khả dụng. Vui lòng thử lại sau.';
        } else if (error.message.includes('HTTP error! status: 500')) {
            errorMessage = '💥 Lỗi máy chủ. Vui lòng thử lại sau hoặc liên hệ hỗ trợ.';
        } else if (error.message.includes('HTTP error! status: 400')) {
            errorMessage = '📝 Yêu cầu không hợp lệ. Vui lòng kiểm tra lại tin nhắn.';
        }
        
        addMessageToChat('assistant', errorMessage);
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
        // Handle multiline messages (especially for error messages with suggestions)
        if (message.includes('\n')) {
            messageDiv.innerHTML = message.replace(/\n/g, '<br>');
        } else {
            messageDiv.textContent = message;
        }
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