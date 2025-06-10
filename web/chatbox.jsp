<%-- 
    Document   : chatbox
    Created on : Jun 10, 2025, 10:25:17 AM
    Author     : nguye
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>chat box</title>
    </head>
    <body>
        <div id="chat-container" style="border: 1px solid #ccc; padding: 10px; width: 400px;">
            <div id="chat-output" style="height: 200px; overflow-y: scroll;"></div>
            <form id="chat-form">
                <input type="text" id="user-input" placeholder="Nhập câu hỏi..." style="width: 80%;" />
                <button type="submit">Gửi</button>
            </form>
        </div>

    </body>
</html>
