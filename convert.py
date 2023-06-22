import cv2

# Read image
img = cv2.imread("image.jpg")

# Convert to 1920x1080 （縦横比を維持したまま、このサイズにリサイズする）
height, width, channels = img.shape

tmp_height = 1080
tmp_width = int(width * tmp_height / height)

new_width = 1920
new_height = int(height * new_width / width)
if tmp_height*tmp_width > new_height*new_width:
    new_height = tmp_height
    new_width = tmp_width

resized_img = cv2.resize(img, (new_width, new_height))

# rgbを取得する　1920x1080
# textファイルを作成する
f = open('./vpg_source/data.txt', 'w')

for y in range(108):
    for x in range(192): # xは横
        # RGBを取得
        try:
            rgb = resized_img[y+340, x+950] # y,x
        except:
            rgb = [0, 0, 0]
        # RGBをテキストファイルに書き込む
        # rgbは合わせて24bitの数値として書き込む(16進数で書き込む)
        f.write(f'{rgb[2]:02x}{rgb[1]:02x}{rgb[0]:02x}\n')

f.close()

# 画像を保存する
cv2.imwrite('image2.jpg', resized_img[340:340+108, 950:950+192])
cv2.imwrite('image3.jpg', resized_img)