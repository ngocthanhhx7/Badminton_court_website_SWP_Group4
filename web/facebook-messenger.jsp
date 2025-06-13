<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chat Options</title>
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .chat-dropdown {
                position: fixed;
                bottom: 30px;
                right: 30px;
                z-index: 9999;
            }
            
            .chat-button {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                background: #0084ff;
                color: #fff;
                border: none;
                box-shadow: 0 2px 8px rgba(0,0,0,0.2);
                font-size: 28px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            
            .chat-button:hover {
                transform: scale(1.1);
                background: #0073e6;
            }

            .chat-dropdown-content {
                display: none;
                position: absolute;
                bottom: 70px;
                right: 0;
                background-color: #fff;
                min-width: 200px;
                box-shadow: 0 8px 16px rgba(0,0,0,0.2);
                border-radius: 10px;
                padding: 15px;
            }

            .chat-dropdown-content.show {
                display: block;
            }

            .chat-option {
                display: flex;
                align-items: center;
                padding: 12px 15px;
                color: #333;
                text-decoration: none;
                border-radius: 5px;
                margin-bottom: 10px;
                transition: background-color 0.3s;
                cursor: pointer;
            }

            .chat-option:hover {
                background-color: #f0f2f5;
            }

            .chat-option i {
                margin-right: 10px;
                font-size: 20px;
            }

            .chat-option.ai-chat i {
                color: #0084ff;
            }

            .chat-option.messenger-chat i {
                color: #0084ff;
            }
        </style>
    </head>
    <body>
        <!-- Chat Dropdown -->
        <div class="chat-dropdown">
            <button class="chat-button" onclick="toggleDropdown()">
                <i class="fas fa-comments"></i>
            </button>
            <div class="chat-dropdown-content" id="chatDropdown">
                <!-- AI Chat Option -->
                <div class="chat-option ai-chat" onclick="showAIChat()">
                    <i class="fas fa-robot"></i>
                    Chat với AI
                </div>

                <!-- Messenger Option -->
                <div class="chat-option messenger-chat" onclick="toggleMessenger()">
                    <i class="fab fa-facebook-messenger"></i>
                    Facebook Messenger
                </div>
            </div>
        </div>

        <!-- Facebook Messenger Chat Plugin -->
        <div id="fb-root"></div>

        <!-- Load Facebook SDK -->
        <script>
            window.fbAsyncInit = function() {
                FB.init({
                    xfbml: true,
                    version: 'v18.0'
                });
            };

            (function(d, s, id) {
                var js, fjs = d.getElementsByTagName(s)[0];
                if (d.getElementById(id)) return;
                js = d.createElement(s); js.id = id;
                js.src = 'https://connect.facebook.net/vi_VN/sdk/xfbml.customerchat.js';
                fjs.parentNode.insertBefore(js, fjs);
            }(document, 'script', 'facebook-jssdk'));

            function toggleDropdown() {
                document.getElementById("chatDropdown").classList.toggle("show");
            }

            function showAIChat() {
                document.getElementById("chatbox-container").style.display = 'block';
                document.getElementById("chatbox-toggle-btn").style.display = 'none';
                document.getElementById("chatDropdown").classList.remove("show");
            }

            function toggleMessenger() {
                FB.CustomerChat.toggle();
                document.getElementById("chatDropdown").classList.remove("show");
            }

            // Close dropdown when clicking outside
            window.onclick = function(event) {
                if (!event.target.matches('.chat-button') && 
                    !event.target.matches('.chat-button i')) {
                    var dropdowns = document.getElementsByClassName("chat-dropdown-content");
                    for (var i = 0; i < dropdowns.length; i++) {
                        var openDropdown = dropdowns[i];
                        if (openDropdown.classList.contains('show')) {
                            openDropdown.classList.remove('show');
                        }
                    }
                }
            }
        </script>

        <!-- Facebook Messenger Chat Plugin Code -->
        <div class="fb-customerchat"
             attribution="setup_tool"
             page_id="61560207654521"
             theme_color="#0084ff"
             logged_in_greeting="Xin chào! Chúng tôi có thể giúp gì cho bạn?"
             logged_out_greeting="Xin chào! Chúng tôi có thể giúp gì cho bạn?">
        </div>
    </body>
</html> 