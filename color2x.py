import json
import math as m
 
end_list = []

def gen_font_color(bg_color):
    bg_color = bg_color.replace('#', '')
    r = int(bg_color[:2], 16)
    g = int(bg_color[2:4], 16)
    b = int(bg_color[4:], 16)
    wdist = m.sqrt((255 - r)**2 + (255 - g)**2 + (255 - b)**2)
    bdist = m.sqrt(r**2 + g**2 + b**2)
    if wdist <= bdist:
        return '#333333'
    else:
        return '#eeeeee'


def get_config_txt(path):

    with open(path) as file:
        lines = file.readlines()

    return ''.join(lines)


def write_config(path, text):
    with open(path, 'w+') as file:
        lines = file.write(text)


def define_colors(
    text,
    text_color,
    color_great,
    color_good,
    color_satisfactory,
    color_unsatisfactory,
    color_bad,
    color_critical,
    color_graph_from,
    color_graph_to,
    outline_color,
):
    return text.replace('color1_rd', text_color)\
        .replace('color2_rd', color_great)\
        .replace('color3_rd', color_good)\
        .replace('color4_rd', color_satisfactory)\
        .replace('color5_rd', color_unsatisfactory)\
        .replace('color6_rd', color_bad)\
        .replace('color7_rd', color_critical)\
        .replace('color8_rd', color_graph_from)\
        .replace('color9_rd', color_graph_to)\
        .replace('color10_rd', outline_color)


with open('/home/user/.cache/wal/colors.json') as file:
	stock = json.load(file)

k1 = gen_font_color(stock['colors']['color1'])
k2 = stock['colors']['color1']
k3 = stock['colors']['color2']
k4 = stock['colors']['color3']
k5_alt = stock['colors']['color4']
k5 = gen_font_color(stock['colors']['color7'])
k6 = stock['colors']['color5'] 
k7 = stock['colors']['color6'] 
k8 = stock['colors']['color7']
k9 = '#ff0000'

k10 = '333333' if k1 == '#eeeeee' else '#eeeeee'

#txt = get_config_txt('~/.config/conky/user-defined.conkyrc')
txt = get_config_txt('/home/user/.config/conky/user-defined.conkyrc')
txt = define_colors(
    txt,
    text_color=k1.replace('#', ''),
    color_great=k1.replace('#', ''),
    color_good=k6.replace('#', ''),
    color_satisfactory=k5_alt.replace('#', ''),
    color_unsatisfactory=k4.replace('#', ''),
    color_bad=k3.replace('#', ''),
    color_critical=k2.replace('#', ''),
    color_graph_from=k5_alt.replace('#', ''),
    color_graph_to=k3.replace('#', ''),
    outline_color=k10.replace('#', '')
)
write_config(
    '/home/user/.config/conky/config.conkyrc',
    txt
)

 
#list1 = ["dwm.normfgcolor: ", "dwm.titlenormfgcolor: ", "dwm.tagsnormfgcolor: ", "dwm.urgfgcolor: ", ]
list1 = ["dwm.urgfgcolor: ", "dwm.titlenormfgcolor: ", "dwm.normfgcolor: ", "dwm.tagsnormfgcolor: "]
 
list2 = ["dwm.normbgcolor: ", "dwm.titlenormbgcolor: ", "dwm.tagsnormbgcolor: ", "dwm.hidnormbgcolor: ", "dwm.hidselbgcolor: ", "dwm.urgbgcolor: "]
 
list3 = ["dwm.normbordercolor: ", "dwm.titlenormbordercolor: ", "dwm.tagsnormbordercolor: "]
 
list4 = ["dwm.normfloatcolor: ", "dwm.titlenormfloatcolor: ", "dwm.tagsnormfloatcolor: ", "dwm.urgfloatcolor: "]
 
# list5 = ["dwm.selfgcolor: "]
list5 = ["dwm.titleselfgcolor: ", "dwm.tagsselfgcolor: ", "dwm.selfgcolor: "]
 
list6 = ["dwm.selbgcolor: ", "dwm.selbordercolor: ", "dwm.selfloatcolor: ", "dwm.titleselbgcolor: ", "dwm.titleselbordercolor: ", "dwm.titleselfloatcolor: ", "dwm.tagsselbgcolor: ", "dwm.tagsselbordercolor: ", "dwm.tagsselfloatcolor: ", "dwm.hidnormfgcolor: "]
 
list7 = ["dwm.hidselfgcolor: "]
 
list8 = ["dwm.urgbordercolor: "]
 
list9 = []
 
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
     

