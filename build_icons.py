import cv2
import numpy as np
from PIL import Image

# 1. Load image
img_path = r'C:/Users/Hamed/.gemini/antigravity/brain/2e794828-0c27-48e0-b8bf-0223425e47d4/.user_uploaded/media_1795261431363_2cdfe935.jpg'
img = cv2.imread(img_path)
img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB).astype(np.float32)
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# 2. Flood fill background from corner
mask = np.zeros((1026, 1026), np.uint8)
flags = 4 | cv2.FLOODFILL_FIXED_RANGE | (255 << 8)
cv2.floodFill(gray.copy(), mask, (0, 0), 0, loDiff=5, upDiff=5, flags=flags)
bg_seed = (mask[1:1025, 1:1025] != 0)

# Also check seed at (512, 190) between headband and cloud
if not bg_seed[190, 512]:
    mask2 = np.zeros((1026, 1026), np.uint8)
    cv2.floodFill(gray.copy(), mask2, (512, 190), 0, loDiff=5, upDiff=5, flags=flags)
    bg_seed = bg_seed | (mask2[1:1025, 1:1025] != 0)

# Dilate the background seed slightly so transition zone is fully covered
kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (5, 5))
bg_zone = cv2.dilate(bg_seed.astype(np.uint8), kernel, iterations=2) != 0

# Compute alpha
alpha = np.ones((1024, 1024), dtype=np.float32) * 255.0

# In bg_zone:
# Luminance calculation
lum = 0.299 * img_rgb[:, :, 0] + 0.587 * img_rgb[:, :, 1] + 0.114 * img_rgb[:, :, 2]
t_high = 252.0
t_low = 210.0

alpha_ramp = np.clip((t_high - lum) / (t_high - t_low) * 255.0, 0.0, 255.0)
alpha[bg_zone] = alpha_ramp[bg_zone]

# Foreground color de-fringing (un-premultiply assuming white background 254)
a_norm = np.clip(alpha / 255.0, 0.001, 1.0)[:, :, np.newaxis]
rgb_clean = np.clip((img_rgb - (1.0 - a_norm) * 254.0) / a_norm, 0.0, 255.0)

# RGBA image
rgba = np.dstack([rgb_clean, alpha]).astype(np.uint8)

# 3. Crop tightly with 1:1 aspect ratio and margin
y_idx, x_idx = np.where(alpha > 15)
x1, y1, x2, y2 = x_idx.min(), y_idx.min(), x_idx.max(), y_idx.max()
w = x2 - x1 + 1
h = y2 - y1 + 1
max_dim = max(w, h)

# Add 3% margin around max dimension
margin = int(max_dim * 0.035)
target_dim = max_dim + 2 * margin

# Center cropped content
cx = (x1 + x2) // 2
cy = (y1 + y2) // 2

crop_x1 = cx - target_dim // 2
crop_y1 = cy - target_dim // 2
crop_x2 = crop_x1 + target_dim
crop_y2 = crop_y1 + target_dim

# Create square canvas
canvas = np.zeros((target_dim, target_dim, 4), dtype=np.uint8)

# Calculate slice coordinates
src_x1 = max(0, crop_x1)
src_y1 = max(0, crop_y1)
src_x2 = min(1024, crop_x2)
src_y2 = min(1024, crop_y2)

dst_x1 = src_x1 - crop_x1
dst_y1 = src_y1 - crop_y1
dst_x2 = dst_x1 + (src_x2 - src_x1)
dst_y2 = dst_y1 + (src_y2 - src_y1)

canvas[dst_y1:dst_y2, dst_x1:dst_x2] = rgba[src_y1:src_y2, src_x1:src_x2]

# PIL Image
full_img = Image.fromarray(canvas, mode='RGBA')
full_img.save('res/microsip_preview.png')
print('Saved res/microsip_preview.png, size:', full_img.size)

# Generate microsip.ico
ico_sizes = [(256, 256), (128, 128), (64, 64), (48, 48), (32, 32), (24, 24), (20, 20), (16, 16)]
full_img.save('res/microsip.ico', format='ICO', sizes=ico_sizes)
print('Saved res/microsip.ico')

# Generate tray_inactive.ico (grayscale)
gray_arr = np.zeros_like(canvas)
lum_val = (0.299 * canvas[:, :, 0] + 0.587 * canvas[:, :, 1] + 0.114 * canvas[:, :, 2]).astype(np.uint8)
gray_arr[:, :, 0] = lum_val
gray_arr[:, :, 1] = lum_val
gray_arr[:, :, 2] = lum_val
gray_arr[:, :, 3] = canvas[:, :, 3]

gray_img = Image.fromarray(gray_arr, mode='RGBA')
tray_sizes = [(32, 32), (24, 24), (20, 20), (16, 16)]
gray_img.save('res/tray_inactive.ico', format='ICO', sizes=tray_sizes)
print('Saved res/tray_inactive.ico')
