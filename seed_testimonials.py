"""
Seed script to add initial testimonials to the database.
Run this after running migrations to add the Testimonial model.

Usage:
    python seed_testimonials.py
"""

from website import app, db, User, Course, Testimonial
from datetime import datetime, timezone

def seed_testimonials():
    with app.app_context():
        print("🌱 Seeding testimonials...")

        # Check if we already have testimonials
        existing = Testimonial.query.count()
        if existing > 0:
            print(f"⚠️  Database already has {existing} testimonials. Skipping seed.")
            return

        # Get or create seed users
        user1 = User.query.filter_by(username='ahmad_saeed').first()
        if not user1:
            from flask_bcrypt import Bcrypt
            bcrypt = Bcrypt(app)
            user1 = User(
                username='ahmad_saeed',
                password=bcrypt.generate_password_hash('password123').decode('utf-8'),
                full_name='Ahmad ibn Saeed',
                email='ahmad@example.com',
                role='user'
            )
            db.session.add(user1)
            db.session.flush()

        user2 = User.query.filter_by(username='fatimah_ali').first()
        if not user2:
            from flask_bcrypt import Bcrypt
            bcrypt = Bcrypt(app)
            user2 = User(
                username='fatimah_ali',
                password=bcrypt.generate_password_hash('password123').decode('utf-8'),
                full_name='Fatimah Ali',
                email='fatimah@example.com',
                role='user'
            )
            db.session.add(user2)
            db.session.flush()

        user3 = User.query.filter_by(username='yusuf_khan').first()
        if not user3:
            from flask_bcrypt import Bcrypt
            bcrypt = Bcrypt(app)
            user3 = User(
                username='yusuf_khan',
                password=bcrypt.generate_password_hash('password123').decode('utf-8'),
                full_name='Yusuf Khan',
                email='yusuf@example.com',
                role='user'
            )
            db.session.add(user3)
            db.session.flush()

        # Get first available courses (you may need to adjust based on your courses)
        courses = Course.query.order_by(Course.year, Course.name).all()

        if len(courses) == 0:
            print("⚠️  No courses in database. Please add at least 1 course first.")
            return

        # Use whatever courses are available
        course1 = courses[0]
        course2 = courses[1] if len(courses) > 1 else courses[0]
        course3 = courses[2] if len(courses) > 2 else courses[0]

        # Testimonial 1
        t1 = Testimonial(
            user_id=user1.id,
            course_id=course1.id,
            name='Ahmad ibn Saeed',
            rating=5,
            review='The courses have really deepened my understanding of Islam. Structured, clear, and inspiring.',
            status='approved',
            created_at=datetime.now(timezone.utc)
        )

        # Testimonial 2
        t2 = Testimonial(
            user_id=user2.id,
            course_id=course2.id,
            name='Fatimah Ali',
            rating=5,
            review='Excellent teachers and very detailed explanations. I feel more connected to my studies.',
            status='approved',
            created_at=datetime.now(timezone.utc)
        )

        # Testimonial 3
        t3 = Testimonial(
            user_id=user3.id,
            course_id=course3.id,
            name='Yusuf Khan',
            rating=4,
            review='Really beneficial content. Would love even more interactive quizzes, but overall very strong.',
            status='approved',
            created_at=datetime.now(timezone.utc)
        )

        db.session.add_all([t1, t2, t3])
        db.session.commit()

        print("✅ Successfully seeded 3 testimonials!")
        print(f"   - Ahmad ibn Saeed (5 stars) → {course1.name}")
        print(f"   - Fatimah Ali (5 stars) → {course2.name}")
        print(f"   - Yusuf Khan (4 stars) → {course3.name}")

if __name__ == '__main__':
    seed_testimonials()
