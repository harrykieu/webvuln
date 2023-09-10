import flet
from flet import Page, TextField, Image ,Text,colors,TextStyle,InputBorder,Container, FilledButton
import time
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
        
    def on_changed_text(e):
        result.value = getCmd(e.control.value)
        getCmd(e.control.value)
        print(e.control.value)
        page.update()

    def run_graph(e):
        
        try:
            process = subprocess.run("python .\demo_app\GUI\graph_test.py", shell=True, text=True)
            if process.returncode == 0:
                print("Success")
                image.src = './demo_app/GUI/asset/graph.png'
                page.update(image)
        except subprocess.CalledProcessError as e:
            print(f"Error: {e}")
            return "Can't run the graph"
# Duration??

    container = Container(height='30px')
    imageButton = FilledButton('Run demo graph',on_click=run_graph)
    result = Text(color=colors.BLACK,font_family='Montserrat',size=20)
    cmd = TextField(label='Enter the command line CMD and press Enter',width=500,height=70,on_submit=on_changed_text,bgcolor=colors.GREY_500,label_style=TextStyle(color=colors.BLACK,font_family='Arial'),color=colors.BLACK,border=InputBorder.UNDERLINE,filled=True,prefix_text="/>>",prefix_style=TextStyle(color=colors.BLACK))
    image = Image(src='./demo_app/GUI/asset/cat.jpg',width=500,height=500,fit=flet.ImageFit.CONTAIN)

    # run = TextButton(content='Run')
    page.add(cmd,container,result, imageButton,image)
    page.update()

flet.app(target=main, assets_dir="./assets/fonts")

