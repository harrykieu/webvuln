import flet
from flet import Page, TextField, TextButton,Text,colors,Row,TextStyle,InputBorder,Container,Column
from io import BytesIO
import json
from main import main as scanner
import subprocess

def main(page: Page):
    page.title = "Run CMD"
    page.vertical_alignment = "center"  # Corrected attribute name
    page.horizontal_alignment = "center"  # Corrected attribute name
    page.scroll = "always"
    page.bgcolor = colors.WHITE
    page.fonts={
        "Montserrat":"https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,400;0,500;1,300;1,400&display=swap"
    }


    def getCmd(e):
        try:
            result = subprocess.check_output({e}, shell=True, text=True)
            print(result)
            return result
        except subprocess.CalledProcessError as e:
            print(f"Error: {e}")
            return "Can't run the cmd line"
        
    
# doi lai e items
# nghien cuu pyc convert python -> C
# tao file requirement.txt cho ae cai library

    def on_changed_text(e):
        result.value = getCmd(e.control.value)
        getCmd(e.control.value)
        print(e.control.value)
        page.update()

    def scan():
        url_to_scan = input_url.control.value
        result.value = scanner(url_to_scan)
        print(result.value)

    input_url = TextField(label='Input url',width=500,height=70,color=colors.BLACK,label_style=TextStyle(color=colors.BLACK),border_color=colors.BLACK,on_submit=scan)
    container = Container(height='30px')

    result = Text(color=colors.BLACK,font_family='Montserrat',size=20)
    cmd = TextField(label='Enter the command line CMD and press Enter',width=500,height=70,on_submit=on_changed_text,bgcolor=colors.GREY_500,label_style=TextStyle(color=colors.BLACK,font_family='Arial'),color=colors.BLACK,border=InputBorder.UNDERLINE,filled=True,prefix_text="/>>",prefix_style=TextStyle(color=colors.BLACK))
    # run = TextButton(content='Run')
    page.add(cmd,input_url,container,result)
    page.update()

flet.app(target=main, assets_dir="./assets/fonts")
