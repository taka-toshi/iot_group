import cv2
import numpy as np

# define H, W
H = 108
W = 192

# Read image
img = cv2.imread("image.jpg")

# Convert to WxH （縦横比を維持したまま、このサイズにリサイズする）
height, width, channels = img.shape

tmp_height = H
tmp_width = int(width * tmp_height / height)

new_width = W
new_height = int(height * new_width / width)
if tmp_height*tmp_width > new_height*new_width:
    new_height = tmp_height
    new_width = tmp_width

resized_img = cv2.resize(img, (new_width, new_height))

# rgbを取得する　WxH
# textファイルを作成する
f = open('./vpg_source/data.txt', 'w')

for y in range(H):
    for x in range(W): # xは横
        # RGBを取得
        try:
            rgb = resized_img[y, x]
        except:
            rgb = [0, 0, 0]
        # RGBをテキストファイルに書き込む
        # rgbは合わせて24bitの数値として書き込む(16進数で書き込む)
        f.write(f'{rgb[2]:02x}{rgb[1]:02x}{rgb[0]:02x}\n')

f.close()

# 画像を保存する
cv2.imwrite('image2.jpg', resized_img)

# ===============================================
# deta.txtから読み込む
memory = []

g = open('./vpg_source/data.txt', 'r')
for rgb in g:
    memory.append([int(rgb[4:6], 16), int(rgb[2:4], 16), int(rgb[0:2], 16)])

memory = np.array(memory)
memory = memory.reshape(H, W, 3)

# 画像を表示
cv2.imwrite('image3.jpg', memory)