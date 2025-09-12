document.addEventListener('DOMContentLoaded', function() {
    const welcomeBtn = document.getElementById('welcomeBtn');
    if (welcomeBtn) {
        welcomeBtn.addEventListener('click', function() {
            alert('Welcome to my homepage! Thank you for visiting.');
        });
    }
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const name = document.getElementById('name').value;
            const email = document.getElementById('email').value;
            const subject = document.getElementById('subject').value;
            const message = document.getElementById('message').value;
            if (name && email && subject && message) {
                alert(`Thank you, ${name}! Your message has been sent. I'll get back to you soon.`);
                contactForm.reset();
            } else {
                alert('Please fill out all fields before submitting.');
            }
        });
    }
    const navbar = document.querySelector('.navbar');
    if (navbar) {
        window.addEventListener('scroll', function() {
            if (window.scrollY > 100) {
                navbar.style.backgroundColor = '#004a99';
            } else {
                navbar.style.backgroundColor = '';
            }
        });
    }
    const galleryImages = document.querySelectorAll('.img-thumbnail');
    galleryImages.forEach(image => {
        image.addEventListener('click', function() {
            const modal = document.createElement('div');
            modal.style.position = 'fixed';
            modal.style.top = '0';
            modal.style.left = '0';
            modal.style.width = '100%';
            modal.style.height = '100%';
            modal.style.backgroundColor = 'rgba(0, 0, 0, 0.8)';
            modal.style.display = 'flex';
            modal.style.justifyContent = 'center';
            modal.style.alignItems = 'center';
            modal.style.zIndex = '1000';
            const modalImg = document.createElement('img');
            modalImg.src = this.src;
            modalImg.style.maxWidth = '80%';
            modalImg.style.maxHeight = '80%';
            modalImg.style.boxShadow = '0 0 20px rgba(255, 255, 255, 0.3)';
            modal.appendChild(modalImg);
            modal.addEventListener('click', function() {
                document.body.removeChild(modal);
            });
            document.body.appendChild(modal);
        });
    });
});
