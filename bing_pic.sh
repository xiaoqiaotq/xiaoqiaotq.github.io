# 参考 https://allanhao.com/2022/07/19/2022-07-19-bing-daily-picture/
RESULT=$(curl -k -s  "https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1")
image_url=$(echo "${RESULT}" | jq -r '.images[0].url')
echo "image: \"https://cn.bing.com$image_url\""