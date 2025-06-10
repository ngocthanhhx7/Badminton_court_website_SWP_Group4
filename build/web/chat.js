document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("chat-form");
    const input = document.getElementById("user-input");
    const output = document.getElementById("chat-output");

    form.addEventListener("submit", function (e) {
        e.preventDefault();
        const message = input.value.trim();
        if (!message) return;

        output.innerHTML += "<div><b>Bạn:</b> " + message + "</div>";

        fetch("chat", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: "message=" + encodeURIComponent(message),
        })
        .then(response => response.text())
        .then(data => {
            output.innerHTML += "<div><b>ChatGPT:</b> " + data + "</div>";
            output.scrollTop = output.scrollHeight;
            input.value = "";
        });
    });
});
