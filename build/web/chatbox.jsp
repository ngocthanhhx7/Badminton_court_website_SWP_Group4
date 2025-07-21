<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>chatGpt</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <style>
            .form-background {
                background-color: #eaf4ff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            #chatbox-toggle-btn {
                position: fixed;
                bottom: 30px;
                right: 30px;
                z-index: 10000;
                width: 60px;
                height: 60px;
                border-radius: 50%;
                background: #007bff;
                color: #fff;
                border: none;
                box-shadow: 0 2px 8px rgba(0,0,0,0.2);
                font-size: 28px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
            }
            #chatbox-container { display: none; }
            .message {
                margin: 10px 0;
                padding: 10px;
                border-radius: 10px;
                max-width: 80%;
                word-wrap: break-word;
            }
            
            .user-message {
                background-color: #007bff;
                color: white;
                margin-left: auto;
                text-align: right;
            }
            
            .assistant-message {
                background-color: #f8f9fa;
                color: #333;
                border: 1px solid #dee2e6;
            }
            
            .loading-dots {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 4px;
            }
            
            .loading-dots span {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background-color: #007bff;
                animation: loading 1.4s infinite ease-in-out;
            }
            
            .loading-dots span:nth-child(1) { animation-delay: -0.32s; }
            .loading-dots span:nth-child(2) { animation-delay: -0.16s; }
            
            @keyframes loading {
                0%, 80%, 100% {
                    transform: scale(0);
                    opacity: 0.5;
                }
                40% {
                    transform: scale(1);
                    opacity: 1;
                }
            }
        </style>

        <meta charset="UTF-8">

    </head>
    <body>
        <!-- Chat Interface -->
        <button id="chatbox-toggle-btn" onclick="showChatbox()" style="position: fixed; bottom: 30px; right: 30px; width: 60px; height: 60px; border-radius: 50%; background: #007bff; color: #fff; border: none; box-shadow: 0 2px 8px rgba(0,0,0,0.2); font-size: 28px; display: flex; align-items: center; justify-content: center; cursor: pointer; z-index: 10000;">
            <i class="fas fa-comments"></i>
        </button>

        <div id="chatbox-container" style="position: fixed; bottom: 30px; right: 30px; width: 350px; z-index: 9999; display: none;">
            <div class="card shadow">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    Chat với AI
                    <span style="cursor:pointer;" onclick="hideChatbox()">&times;</span>
                </div>
                <div class="card-body" style="height: 300px; overflow-y: auto;" id="chat-messages"></div>
                <div class="card-footer">
                    <div class="input-group">
                        <input type="text" id="message-input" class="form-control" placeholder="Nhập câu hỏi...">
                        <button class="btn btn-primary" onclick="sendMessage()">Gửi</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="js/chat.js"></script>
        <script>
            function hideChatbox() {
                document.getElementById('chatbox-container').style.display = 'none';
                document.getElementById('chatbox-toggle-btn').style.display = 'flex';
            }
        </script>

    </body>
</html>
