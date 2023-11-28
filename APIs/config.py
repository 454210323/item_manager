import os


class Config:
    DEBUG = False
    TESTING = False
    SECRET_KEY = "your-secret-key"
    SQLALCHEMY_DATABASE_URI = "postgresql://default:vOQz1y3nrNtU@ep-red-hill-15191895-pooler.ap-southeast-1.postgres.vercel-storage.com:5432/verceldb"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ECHO = True
    UPLOAD_FOLDER = "resource/upload_file"
    GENERATED_FOLDER = "resource/generated_file"


class ProductionConfig(Config):
    pass


class StagingConfig(Config):
    DEBUG = True


class DevelopmentConfig(Config):
    DEBUG = True


class TestingConfig(Config):
    TESTING = True
