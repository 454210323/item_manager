from flask import Flask, request, jsonify
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app)

# 定义静态文件夹路径
UPLOAD_FOLDER = "static/images"
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

# 创建静态文件夹如果不存在
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)


@app.route("/upload", methods=["POST"])
def upload_file():
    if "file" not in request.files or "item_code" not in request.form:
        return jsonify({"error": "No file or item code provided"}), 400

    file = request.files["file"]
    item_code = request.form["item_code"]

    if file.filename == "":
        return jsonify({"error": "No selected file"}), 400

    # 构建新文件名
    filename = f"{item_code}.jpg"
    file_path = os.path.join(app.config["UPLOAD_FOLDER"], filename)

    # 保存文件
    file.save(file_path)

    return (
        jsonify({"message": "File uploaded successfully", "file_path": file_path}),
        200,
    )


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5001)
