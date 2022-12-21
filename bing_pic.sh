# 参考 https://allanhao.com/2022/07/19/2022-07-19-bing-daily-picture/
# https://blog.csdn.net/y1534414425/article/details/107513880
RESULT=$(curl -k -s  "https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=8")
Base_URL="https://cn.bing.com"
image_url=$(echo "${RESULT}" | jq -r '"https://cn.bing.com" +  .images[].url + "\\n"')
echo ${image_url}
#echo "image: \"https://cn.bing.com$image_url\""