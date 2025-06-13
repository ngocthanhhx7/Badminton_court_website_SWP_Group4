document.addEventListener('DOMContentLoaded', function() {
    // Thêm các elements cần thiết
    const transitionElement = document.createElement('div');
    transitionElement.className = 'page-transition';
    document.body.appendChild(transitionElement);

    const loadingSpinner = document.createElement('div');
    loadingSpinner.className = 'loading-spinner';
    document.body.appendChild(loadingSpinner);

    // Lấy tất cả các link trong trang
    const links = document.querySelectorAll('a');
    
    links.forEach(link => {
        // Bỏ qua các link có target="_blank" hoặc các link ngoài trang
        if (link.target === '_blank' || link.hostname !== window.location.hostname) {
            return;
        }

        link.addEventListener('click', function(e) {
            e.preventDefault();
            const href = this.getAttribute('href');

            // Thêm class cho nội dung
            document.body.classList.add('reveal-content', 'reveal-out');
            document.body.classList.add('fade-content', 'fade-out');
            
            // Kích hoạt loading spinner
            loadingSpinner.classList.add('active');
            
            // Kích hoạt hiệu ứng chuyển trang
            transitionElement.classList.add('active');

            // Chuyển trang sau khi hiệu ứng hoàn thành
            setTimeout(() => {
                window.location.href = href;
            }, 400);
        });
    });

    // Xử lý khi trang được load
    window.addEventListener('pageshow', function(e) {
        // Xóa các class
        transitionElement.classList.remove('active');
        document.body.classList.remove('reveal-out', 'fade-out');
        loadingSpinner.classList.remove('active');
        
        // Thêm hiệu ứng vào cho nội dung mới
        document.body.classList.add('fade-content');
        setTimeout(() => {
            document.body.classList.remove('fade-content');
        }, 100);
    });

    // Thêm hiệu ứng hover cho các link
    links.forEach(link => {
        if (link.target === '_blank' || link.hostname !== window.location.hostname) {
            return;
        }

        link.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.02)';
            this.style.transition = 'transform 0.2s ease';
        });

        link.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
        });
    });
}); 