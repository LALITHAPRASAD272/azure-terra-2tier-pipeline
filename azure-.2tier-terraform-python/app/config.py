import os

class Config:
    DB_HOST     = os.environ.get('DB_HOST')
    DB_USER     = os.environ.get('DB_USER')
    DB_PASSWORD = os.environ.get('DB_PASSWORD')
    DB_NAME     = os.environ.get('DB_NAME', 'studentdb')

    # ✅ REQUIRED for Azure MySQL (SSL)
    SQLALCHEMY_DATABASE_URI = (
        f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"
        "?ssl_ca=/etc/ssl/certs/ca-certificates.crt"
    )

    SQLALCHEMY_TRACK_MODIFICATIONS = False