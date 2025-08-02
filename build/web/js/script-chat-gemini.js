const chatBody = document.querySelector(".chat-body");
const messageInput = document.querySelector(".message-input");
const sendMessageButton = document.querySelector("#send-message");
const fileInput = document.querySelector("#file-input");
const fileUploadWrapper = document.querySelector(".file-upload-wrapper");
const fileCancelButton = document.querySelector("#file-cancel");
const chatbotToggler = document.querySelector("#chatbot-toggler");
const closeChatbot = document.querySelector("#close-chatbot");


// Api setup
const API_KEY = "AIzaSyD1ClTMuvLuwlugJpmAH1tzGe_pnzSd3Lw";
const API_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${API_KEY}`;
const CHATBOT_API_URL = "/chatbot-api";

const userData = {
    message: null,
    file: {
        data: null,
        mime_type: null
    }
};

// Website context for the chatbot
const websiteContext = `
Bạn là trợ lý AI của trang web BadmintonHub - một hệ thống đặt sân cầu lông trực tuyến. 

Thông tin về hệ thống:
- Website: BadmintonHub - Hệ thống đặt sân cầu lông
- Chức năng chính: Đặt sân cầu lông, xem lịch trống, quản lý đặt sân
- Giờ hoạt động: Thứ 2 - Chủ nhật từ 6:00 - 22:00
- Liên hệ: Hotline 0123-456-789, Email: booking@badmintonhub.com

Các chức năng có thể hỗ trợ:
1. Hướng dẫn cách đặt sân
2. Thông tin về giá cả và chính sách
3. Hỗ trợ khách hàng

`;


const chatHistory = [];

const initialInputHeight = messageInput.scrollHeight;

// Create message element with dynamic classes and return it
const createMessageElement = (content, ...classes) => {
    const div = document.createElement("div");
    div.classList.add("message", ...classes);
    div.innerHTML = content;
    return div;
};

// Function to call chatbot API
const callChatbotAPI = async (action, params = {}) => {
    try {
        const response = await fetch(CHATBOT_API_URL, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ action, ...params })
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        return await response.json();
    } catch (error) {
        console.error("Error calling chatbot API:", error);
        return { error: error.message };
    }
};

// Function to detect user intent and extract information
const detectIntent = (message) => {
    const lowerMessage = message.toLowerCase();
    
    // Check for date patterns
    const datePatterns = [
        /(hôm nay|today)/,
        /(ngày mai|tomorrow)/,
        /(\d{1,2}\/\d{1,2}\/\d{4})/,
        /(\d{4}-\d{2}-\d{2})/
    ];
    
    let detectedDate = null;
    for (const pattern of datePatterns) {
        const match = lowerMessage.match(pattern);
        if (match) {
            if (match[1] === "hôm nay" || match[1] === "today") {
                detectedDate = new Date().toISOString().split('T')[0];
            } else if (match[1] === "ngày mai" || match[1] === "tomorrow") {
                const tomorrow = new Date();
                tomorrow.setDate(tomorrow.getDate() + 1);
                detectedDate = tomorrow.toISOString().split('T')[0];
            } else if (match[2]) {
                // Handle DD/MM/YYYY format
                const parts = match[2].split('/');
                if (parts.length === 3) {
                    detectedDate = `${parts[2]}-${parts[1].padStart(2, '0')}-${parts[0].padStart(2, '0')}`;
                }
            } else if (match[3]) {
                // Handle YYYY-MM-DD format
                detectedDate = match[3];
            }
            break;
        }
    }
    
    // Check for court patterns
    const courtPatterns = [
        /(sân \d+|court \d+)/i,
        /(sân indoor|sân outdoor)/i
    ];
    
    let detectedCourt = null;
    for (const pattern of courtPatterns) {
        const match = lowerMessage.match(pattern);
        if (match) {
            detectedCourt = match[1];
            break;
        }
    }
    
    
    if (lowerMessage.includes("đặt sân") || lowerMessage.includes("booking") || 
        lowerMessage.includes("hướng dẫn") || lowerMessage.includes("cách đặt")) {
        return { intent: "booking_guide", date: detectedDate, court: detectedCourt };
    }
    
    if (lowerMessage.includes("giá") || lowerMessage.includes("price") || 
        lowerMessage.includes("phí") || lowerMessage.includes("cost")) {
        return { intent: "price_info", date: detectedDate, court: detectedCourt };
    }
    
    if (lowerMessage.includes("liên hệ") || lowerMessage.includes("contact") || 
        lowerMessage.includes("hotline") || lowerMessage.includes("email")) {
        return { intent: "contact_info", date: detectedDate, court: detectedCourt };
    }
    
    return { intent: "general", date: detectedDate, court: detectedCourt };
};

// Generate bot response using API
const generateBotResponse = async (incomingMessageDiv) => {
    const messageElement = incomingMessageDiv.querySelector(".message-text");
    
    // Detect user intent
    const intent = detectIntent(userData.message);
    
    let systemMessage = websiteContext;
    let enhancedUserMessage = userData.message;
    
    // Handle specific intents
    if (intent.intent === "check_availability") {
        try {
            const date = intent.date || new Date().toISOString().split('T')[0];
            const apiResult = await callChatbotAPI("getAvailableSchedules", { date });
            
            if (apiResult.success) {
                const data = apiResult.data;
                systemMessage += `\n\nDữ liệu lịch trống cho ngày ${data.date}:\n`;
                systemMessage += `- Tổng số slot trống: ${data.totalAvailable}\n`;
                
                for (const [courtName, courtInfo] of Object.entries(data.courts)) {
                    systemMessage += `- ${courtName}: ${courtInfo.count} slot trống\n`;
                    systemMessage += `  Khung giờ: ${courtInfo.timeSlots.join(', ')}\n`;
                }
            } else {
                systemMessage += `\n\nKhông thể lấy dữ liệu lịch trống: ${apiResult.error}`;
            }
        } catch (error) {
            systemMessage += `\n\nLỗi khi lấy dữ liệu: ${error.message}`;
        }
    } else if (intent.intent === "booking_guide") {
        try {
            const apiResult = await callChatbotAPI("getBookingInfo");
            if (apiResult.success) {
                const data = apiResult.data;
                systemMessage += `\n\nThông tin đặt sân:\n`;
                systemMessage += `- Các bước đặt sân: ${data.bookingSteps}\n`;
                systemMessage += `- Giờ hoạt động: ${data.workingHours}\n`;
                systemMessage += `- Chính sách hủy: ${data.cancellationPolicy}\n`;
                systemMessage += `- Liên hệ: ${data.contactInfo}\n`;
            }
        } catch (error) {
            systemMessage += `\n\nLỗi khi lấy thông tin đặt sân: ${error.message}`;
        }
    }

    // Prepare chat history with system context
    const messagesWithContext = [
        { role: "user", parts: [{ text: systemMessage }] },
        { role: "model", parts: [{ text: "Tôi hiểu rồi. Tôi là trợ lý AI của BadmintonHub và có thể giúp bạn với các thông tin về đặt sân cầu lông." }] },
        ...chatHistory,
        { role: "user", parts: [{ text: enhancedUserMessage }, ...(userData.file.data ? [{ inline_data: userData.file }] : [])] }
    ];
    
    // API request options
    const requestOptions = {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            contents: messagesWithContext
        })
    }

    try {
        // Fetch bot response from API
        const response = await fetch(API_URL, requestOptions);
        const data = await response.json();
        if (!response.ok) throw new Error(data.error.message);

        // Extract and display bot's response text
        const apiResponseText = data.candidates[0].content.parts[0].text.replace(/\*\*(.*?)\*\*/g, "$1").trim();
        messageElement.innerText = apiResponseText;
        chatHistory.push({
            role: "model",
            parts: [{ text: apiResponseText }]
        });
    } catch (error) {
        messageElement.innerText = error.message;
        messageElement.style.color = "#ff0000";
    } finally {
        userData.file = {};
        incomingMessageDiv.classList.remove("thinking");
        chatBody.scrollTo({ behavior: "smooth", top: chatBody.scrollHeight });
    }
};

// Handle outgoing user message
const handleOutgoingMessage = (e) => {
    e.preventDefault();
    userData.message = messageInput.value.trim();
    messageInput.value = "";
    fileUploadWrapper.classList.remove("file-uploaded");
    messageInput.dispatchEvent(new Event("input"));

    // Create and display user message
    const messageContent = `<div class="message-text"></div>
                            ${userData.file.data ? `<img src="data:${userData.file.mime_type};base64,${userData.file.data}" class="attachment" />` : ""}`;

    const outgoingMessageDiv = createMessageElement(messageContent, "user-message");
    outgoingMessageDiv.querySelector(".message-text").innerText = userData.message;
    chatBody.appendChild(outgoingMessageDiv);
    chatBody.scrollTop = chatBody.scrollHeight;

    // Simulate bot response with thinking indicator after a delay
    setTimeout(() => {
        const messageContent = `<svg class="bot-avatar" xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 1024 1024">
                    <path d="M738.3 287.6H285.7c-59 0-106.8 47.8-106.8 106.8v303.1c0 59 47.8 106.8 106.8 106.8h81.5v111.1c0 .7.8 1.1 1.4.7l166.9-110.6 41.8-.8h117.4l43.6-.4c59 0 106.8-47.8 106.8-106.8V394.5c0-59-47.8-106.9-106.8-106.9zM351.7 448.2c0-29.5 23.9-53.5 53.5-53.5s53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5-53.5-23.9-53.5-53.5zm157.9 267.1c-67.8 0-123.8-47.5-132.3-109h264.6c-8.6 61.5-64.5 109-132.3 109zm110-213.7c-29.5 0-53.5-23.9-53.5-53.5s23.9-53.5 53.5-53.5 53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5zM867.2 644.5V453.1h26.5c19.4 0 35.1 15.7 35.1 35.1v121.1c0 19.4-15.7 35.1-35.1 35.1h-26.5zM95.2 609.4V488.2c0-19.4 15.7-35.1 35.1-35.1h26.5v191.3h-26.5c-19.4 0-35.1-15.7-35.1-35.1zM561.5 149.6c0 23.4-15.6 43.3-36.9 49.7v44.9h-30v-44.9c-21.4-6.5-36.9-26.3-36.9-49.7 0-28.6 23.3-51.9 51.9-51.9s51.9 23.3 51.9 51.9z"></path>
                </svg>
                <div class="message-text">
                    <div class="thinking-indicator">
                        <div class="dot"></div>
                        <div class="dot"></div>
                        <div class="dot"></div>
                    </div>
                </div>`;

        const incomingMessageDiv = createMessageElement(messageContent, "bot-message", "thinking");
        chatBody.appendChild(incomingMessageDiv);
        chatBody.scrollTo({ behavior: "smooth", top: chatBody.scrollHeight });
        generateBotResponse(incomingMessageDiv);
    }, 600);
};

// Handle Enter key press for sending messages
messageInput.addEventListener("keydown", (e) => {
    const userMessage = e.target.value.trim();
    if (e.key === "Enter" && userMessage && !e.shiftKey && window.innerWidth > 768) {
        handleOutgoingMessage(e);
    }
});

messageInput.addEventListener("input", (e) => {
    messageInput.style.height = `${initialInputHeight}px`;
    messageInput.style.height = `${messageInput.scrollHeight}px`;
    document.querySelector(".chat-form").style.boderRadius = messageInput.scrollHeight > initialInputHeight ? "15px" : "32px";
});

// Handle file input change event
fileInput.addEventListener("change", (e) => {
    const file = e.target.files[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = (e) => {
        fileUploadWrapper.querySelector("img").src = e.target.result;
        fileUploadWrapper.classList.add("file-uploaded");
        const base64String = e.target.result.split(",")[1];

        // Store file data in userData
        userData.file = {
            data: base64String,
            mime_type: file.type
        };
        
        fileInput.value = ""; 
    };

    reader.readAsDataURL(file);
});

fileCancelButton.addEventListener("click", (e) => {
    userData.file = {};
    fileUploadWrapper.classList.remove("file-uploaded");
});

const picker = new EmojiMart.Picker({
    theme: "light",
    showSkinTones: "none",
    previewPosition: "none",
    onEmojiSelect: (emoji) => {
        const { selectionStart: start, selectionEnd: end } = messageInput;
        messageInput.setRangeText(emoji.native, start, end, "end");
        messageInput.focus();
    },
    onClickOutside: (e) => {
        if (e.target.id === "emoji-picker") {
            document.body.classList.toggle("show-emoji-picker");
        } else {
            document.body.classList.remove("show-emoji-picker");
        }
    },
});

document.querySelector(".chat-form").appendChild(picker);

fileInput.addEventListener("change", async (e) => {
    const file = e.target.files[0];
    if (!file) return;
    const validImageTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    if (!validImageTypes.includes(file.type)) {
        await Swal.fire({
            icon: 'error',
            title: 'Lỗi',
            text: 'Chỉ chấp nhận file ảnh (JPEG, PNG, GIF, WEBP)',
            confirmButtonText: 'OK'
        });
        resetFileInput();
        return;
    }
    const reader = new FileReader();
    reader.onload = (e) => {
        fileUploadWrapper.querySelector("img").src = e.target.result;
        fileUploadWrapper.classList.add("file-uploaded");
        const base64String = e.target.result.split(",")[1];
        userData.file = {
            data: base64String,
            mime_type: file.type
        };
    };
    reader.readAsDataURL(file);
});

function resetFileInput() {
    fileInput.value = "";
    fileUploadWrapper.classList.remove("file-uploaded");
    fileUploadWrapper.querySelector("img").src = "#";
    userData.file = { data: null, mime_type: null };
    document.querySelector(".chat-form").reset();
}

sendMessageButton.addEventListener("click", (e) => handleOutgoingMessage(e));
document.querySelector("#file-upload").addEventListener("click", (e) => fileInput.click());
chatbotToggler.addEventListener("click", () => document.body.classList.toggle("show-chatbot"));
closeChatbot.addEventListener("click", () => document.body.classList.remove("show-chatbot"));