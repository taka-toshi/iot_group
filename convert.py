import cv2

# Read image
img = cv2.imread("image.jpg")
# Convert to 1920x1080 （縦横比を維持したまま、このサイズにリサイズする）
height, width, channels = img.shape
new_height = 1080
new_width = int(width * new_height / height)
resized_img = cv2.resize(img, (new_width, new_height))

# rgbを取得する　1920x1080
# textファイルを作成する
f = open('./vpg_source/data.txt', 'w')
#g = open('template.txt', 'r')
## gの7行目までをfに書き込む
#for i in range(7):
#    f.write(g.readline())

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

# 画像を表示する
# 1200, 480から192x108を保存する
cv2.imwrite('image2.jpg', resized_img[340:340+108, 950:950+192])