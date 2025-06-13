<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Hoàn thiện hồ sơ</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- <link rel="manifest" href="site.webmanifest"> -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">
        <!-- Place favicon.ico in the root directory -->

        <!-- CSS here -->
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/owl.carousel.min.css">
        <link rel="stylesheet" href="css/magnific-popup.css">
        <link rel="stylesheet" href="css/font-awesome.min.css">
        <link rel="stylesheet" href="css/themify-icons.css">
        <link rel="stylesheet" href="css/nice-select.css">
        <link rel="stylesheet" href="css/flaticon.css">
        <link rel="stylesheet" href="css/gijgo.css">
        <link rel="stylesheet" href="css/animate.css">
        <link rel="stylesheet" href="css/slicknav.css">
        <link rel="stylesheet" href="css/style.css">
        <!-- <link rel="stylesheet" href="css/responsive.css"> -->
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
        </style>

        <link rel="stylesheet" href="css/owl.carousel.min.css">
        <link rel="stylesheet" href="css/page-transitions.css">
        <script src="js/jquery.min.js"></script>
        <script src="js/owl.carousel.min.js"></script>
        <script src="js/effects.js"></script>
        <script src="js/page-transitions.js"></script>
        <meta charset="UTF-8">

    </head>
    <body>

        <div id="chatbox-container" style="position: fixed; bottom: 30px; right: 30px; width: 350px; z-index: 9999;">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">Chat với AI <span style="float:right; cursor:pointer;" onclick="hideChatbox()">&times;</span></div>
                <div class="card-body" style="height: 300px; overflow-y: auto;" id="chatOutput"></div>
                <div class="card-footer">
                    <div class="input-group">
                        <input type="text" id="chatInput" class="form-control" placeholder="Nhập câu hỏi..." onkeydown="if(event.key==='Enter'){sendMessageToGPT();}">
                        <button class="btn btn-primary" onclick="sendMessageToGPT()">Gửi</button>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function showChatbox() {
                document.getElementById('chatbox-container').style.display = 'block';
                document.getElementById('chatbox-toggle-btn').style.display = 'none';
            }
            function hideChatbox() {
                document.getElementById('chatbox-container').style.display = 'none';
                document.getElementById('chatbox-toggle-btn').style.display = 'flex';
            }
            function sendMessageToGPT() {
                var message = document.getElementById("chatInput").value;
                if (!message.trim()) return;
                
                var chatOutput = document.getElementById("chatOutput");
                chatOutput.innerHTML += `<div class='mb-2'><b>Bạn:</b> ${message}</div>`;
                document.getElementById("chatInput").value = "";
                
                // Show loading indicator
                chatOutput.innerHTML += `<div class='mb-2 text-muted'><i>Đang xử lý...</i></div>`;
                
                fetch('ChatGPTServlet', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'message=' + encodeURIComponent(message)
                })
                .then(response => response.json())
                .then(data => {
                    // Remove loading indicator
                    chatOutput.removeChild(chatOutput.lastChild);
                    
                    var reply = "";
                    if (data.error) {
                        reply = "Lỗi: " + data.error;
                    } else {
                        try {
                            reply = data.choices[0].message.content;
                        } catch (e) {
                            reply = "Không thể xử lý phản hồi từ AI!";
                            console.error("Error parsing response:", e);
                        }
                    }
                    
                    if (!reply || reply.trim() === "") {
                        reply = "AI không có câu trả lời!";
                    }
                    
                    chatOutput.innerHTML += `<div class='mb-2 text-primary'><b>AI:</b> ${reply}</div>`;
                    chatOutput.scrollTop = chatOutput.scrollHeight;
                })
                .catch(error => {
                    // Remove loading indicator
                    chatOutput.removeChild(chatOutput.lastChild);
                    
                    console.error("Error:", error);
                    chatOutput.innerHTML += `<div class='mb-2 text-danger'><b>AI:</b> Lỗi kết nối hoặc API! Vui lòng thử lại sau.</div>`;
                    chatOutput.scrollTop = chatOutput.scrollHeight;
                });
            }
        </script> 



        <!-- JS here -->
        <script src="js/vendor/modernizr-3.5.0.min.js"></script>
        <script src="js/vendor/jquery-1.12.4.min.js"></script>
        <script src="js/popper.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/owl.carousel.min.js"></script>
        <script src="js/isotope.pkgd.min.js"></script>
        <script src="js/ajax-form.js"></script>
        <script src="js/waypoints.min.js"></script>
        <script src="js/jquery.counterup.min.js"></script>
        <script src="js/imagesloaded.pkgd.min.js"></script>
        <script src="js/scrollIt.js"></script>
        <script src="js/jquery.scrollUp.min.js"></script>
        <script src="js/wow.min.js"></script>
        <script src="js/nice-select.min.js"></script>
        <script src="js/jquery.slicknav.min.js"></script>
        <script src="js/jquery.magnific-popup.min.js"></script>
        <script src="js/plugins.js"></script>
        <script src="js/gijgo.min.js"></script>

        <!--contact js-->
        <script src="js/contact.js"></script>
        <script src="js/jquery.ajaxchimp.min.js"></script>
        <script src="js/jquery.form.js"></script>
        <script src="js/jquery.validate.min.js"></script>
        <script src="js/mail-script.js"></script>

        <script src="js/main.js"></script>
        <script>
            $('#datepicker').datepicker({
                iconsLibrary: 'fontawesome',
                icons: {
                    rightIcon: '<span class="fa fa-caret-down"></span>'
                }
            });
            $('#datepicker2').datepicker({
                iconsLibrary: 'fontawesome',
                icons: {
                    rightIcon: '<span class="fa fa-caret-down"></span>'
                }

            });
        </script>


    </body>
</html>
