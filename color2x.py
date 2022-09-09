import json
 
end_list = []

def gen_font_color(bg_color):
	bg_color = bg_color.replace('#', '')
	bg_color_10 = int(bg_color, 16)
	if int('000000', 16) - bg_color_10 <= bg_color_10 - int('ffffff', 16):
		return '#333333'
	else:
		return '#eeeeee'
 
with open('/home/user/.cache/wal/colors.json') as file:
	stock = json.load(file)

k1 = gen_font_color(stock['colors']['color1'])
#k1 = stock['colors']['color0']
k2 = stock['colors']['color1']
k3 = stock['colors']['color2']
k4 = stock['colors']['color3']
#k5 = stock['colors']['color4']
k5 = gen_font_color(stock['colors']['color7'])
k6 = stock['colors']['color5'] 
k7 = stock['colors']['color6'] 
k8 = stock['colors']['color7']
#k9 = stock['colors']['color0']
k9 = k1
 
#list1 = ["dwm.normfgcolor: ", "dwm.titlenormfgcolor: ", "dwm.tagsnormfgcolor: ", "dwm.urgfgcolor: ", ]
list1 = ["dwm.normfgcolor: ", "dwm.titlenormfgcolor: ", "dwm.tagsnormfgcolor: "]
 
list2 = ["dwm.normbgcolor: ", "dwm.titlenormbgcolor: ", "dwm.tagsnormbgcolor: ", "dwm.hidnormbgcolor: ", "dwm.hidselbgcolor: ", "dwm.urgbgcolor: ", "dwm.selfgcolor: "]
 
list3 = ["dwm.normbordercolor: ", "dwm.titlenormbordercolor: ", "dwm.tagsnormbordercolor: "]
 
list4 = ["dwm.normfloatcolor: ", "dwm.titlenormfloatcolor: ", "dwm.tagsnormfloatcolor: ", "dwm.urgfloatcolor: "]
 
# list5 = ["dwm.selfgcolor: "]
list5 = ["dwm.urgfgcolor: ",]
 
list6 = ["dwm.selbgcolor: ", "dwm.selbordercolor: ", "dwm.selfloatcolor: ", "dwm.titleselbgcolor: ", "dwm.titleselbordercolor: ", "dwm.titleselfloatcolor: ", "dwm.tagsselbgcolor: ", "dwm.tagsselbordercolor: ", "dwm.tagsselfloatcolor: ", "dwm.hidnormfgcolor: "]
 
list7 = ["dwm.hidselfgcolor: "]
 
list8 = ["dwm.urgbordercolor: "]
 
list9 = ["dwm.titleselfgcolor: ", "dwm.tagsselfgcolor: "]
 
for event in list1:
	string = str(event) + str(k1)
	end_list.append(string)
 
for event in list2:
	string = str(event) + str(k2)
	end_list.append(string)
 
for event in list3:
	string = str(event) + str(k3)
	end_list.append(string)
 
for event in list4:
	string = str(event) + str(k4)
	end_list.append(string)
 
for event in list5:
	string = str(event) + str(k5)
	end_list.append(string)
 
for event in list6:
	string = str(event) + str(k6)
	end_list.append(string)
 
for event in list7:
	string = str(event) + str(k7)
	end_list.append(string)
 
for event in list8:
	string = str(event) + str(k8)
	end_list.append(string)
 
for event in list9:
	string = str(event) + str(k9)
	end_list.append(string)
 
file = open("/home/user/.Xresources", "w")
 
for end_str in end_list:
 
	file.write(str(end_str) + '\n')
 
file.close()
     

