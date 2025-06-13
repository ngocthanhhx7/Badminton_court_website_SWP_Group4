// Hiệu ứng tuyết rơi
function createSnowflake() {
    const snowflake = document.createElement('div');
    snowflake.classList.add('snowflake');
    snowflake.style.left = Math.random() * 100 + 'vw';
    snowflake.style.animationDuration = Math.random() * 3 + 2 + 's';
    snowflake.style.opacity = Math.random();
    snowflake.style.fontSize = Math.random() * 10 + 10 + 'px';
    snowflake.innerHTML = '❄';
    document.body.appendChild(snowflake);

    setTimeout(() => {
        snowflake.remove();
    }, 5000);
}

// Hiệu ứng quả cầu lông bay
function createShuttlecock() {
    const shuttlecock = document.createElement('div');
    shuttlecock.classList.add('shuttlecock');
    shuttlecock.style.left = Math.random() * 100 + 'vw';
    shuttlecock.style.animationDuration = Math.random() * 2 + 3 + 's';
    shuttlecock.innerHTML = '🏸';
    document.body.appendChild(shuttlecock);

    setTimeout(() => {
        shuttlecock.remove();
    }, 5000);
}

// Khởi tạo các hiệu ứng
function initEffects() {
    // Tạo tuyết rơi mỗi 100ms
    setInterval(createSnowflake, 100);

    // Tạo quả cầu lông bay mỗi 3 giây
    setInterval(createShuttlecock, 3000);
}

// Thêm CSS cho các hiệu ứng
const style = document.createElement('style');
style.textContent = `
    .snowflake {
        position: fixed;
        top: -10px;
        color: white;
        text-shadow: 0 0 5px #fff;
        z-index: 1000;
        pointer-events: none;
        animation: fall linear forwards;
    }

    .shuttlecock {
        position: fixed;
        top: 50%;
        font-size: 30px;
        z-index: 1000;
        pointer-events: none;
        animation: fly linear forwards;
    }

    @keyframes fall {
        to {
            transform: translateY(100vh) rotate(360deg);
        }
    }

    @keyframes fly {
        0% {
            transform: translateX(-100vw) translateY(0) rotate(0deg);
        }
        50% {
            transform: translateX(50vw) translateY(-100px) rotate(180deg);
        }
        100% {
            transform: translateX(100vw) translateY(0) rotate(360deg);
        }
    }
`;
document.head.appendChild(style);

// Khởi chạy hiệu ứng khi trang đã load xong
document.addEventListener('DOMContentLoaded', initEffects); 