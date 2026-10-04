-- UI-only example factory. Call it with the API returned by Luma.luau.
return function(Luma: any): any
    Luma:AddTranslations('Russian',{
        ['UI Library']='Библиотека UI',['Containers']='Контейнеры',['Tabbed section']='Секция со страницами',
        ['First']='Первый',['Second']='Второй',['Third']='Третий',['Display components']='Элементы отображения',
        ['Test controls do not change the game.']='Тестовые элементы не изменяют игру.',
        ['Test overlay']='Тестовый оверлей',['Test overlay: registered below the menu']='Тестовый оверлей: под слоем меню',
        ['Image']='Изображение',['Player list']='Список игроков',['Multiple values']='Несколько значений',
        ['Buttons']='Кнопки',['Test progress']='Тестовый прогресс',['Test console']='Тестовая консоль',
        ['Selector']='Переключатель вариантов',
    })
    local W=Luma:CreateWindow({
        Title='Luma',Author='x089',Folder='LumaDemo060',Badge='Zero',
        Version=Luma.Version,Width=900,Height=660,SidebarWidth=200,
        Dashboard=true,Settings=true,Server=false,Tools=false,LoadNotification=false,
    })
    local nav=W:Group('UI Library')
    local tab=nav:Tab({Name='Components',Icon='layout-grid'})
    local left=tab:Section({Name='Basic controls',Side='Left'})
    left:Toggle({Name='Test toggle',Flag='demo_toggle',Default=false,Keybind='F2',Callback=function(on: boolean)print('[Luma Demo] Toggle:',on)end})
    left:Slider({Name='Test slider',Flag='demo_slider',Min=0,Max=100,Default=25,Callback=function(value: number)print('[Luma Demo] Slider:',value)end})
    left:Input({Name='Test input',Flag='demo_input',Default='',Placeholder='Enter text'})
    left:Dropdown({Name='Test dropdown',Flag='demo_dropdown',Values={'First','Second','Third'},Default='First'})
    left:Dropdown({Name='Multiple values',Flag='demo_multi',Values={'First','Second','Third'},Multi=true,Default={}})
    left:Segmented({Name='Selector',Flag='demo_segmented',Values={'First','Second'},Default='First'})
    left:ColorPicker({Name='Test color',Flag='demo_color',Default=Color3.fromRGB(94,159,232)})
    left:Keybind({Name='Test keybind',Flag='demo_key',Default='F1',Callback=function()W:Notify({Title='Luma',Content='Test keybind',Duration=2,Sound=true})end})
    local right=tab:Section({Name='Display components',Side='Right'})
    right:Label({Text='Luma UI Lib'})
    right:Paragraph({Title='UI Library',Body='Test controls do not change the game.'})
    right:Info({Name='Made By',Value='x089'})
    right:Progress({Name='Test progress',Value=65,Max=100})
    right:Divider()
    right:Button({Name='Test notification',Callback=function()W:Notify({Title='Luma',Content='This notification closes automatically.',Duration=3,Sound=true})end})
    right:Button({Name='Test dialog',Callback=function()W:Dialog({Title='Luma',Content='Test controls do not change the game.',Buttons={{Name='Close'}}})end})
    right:Button({Name='Test prompt',Callback=function()W:Prompt({Title='Luma',Placeholder='Enter text',Callback=function(text: string)W:Notify({Title='Luma',Content=text,Duration=3})end})end})
    local root,controller=W:CreateVisualLayer('LumaDemoOverlay')
    local label=Instance.new('TextLabel')
    label.AnchorPoint=Vector2.new(0.5,0);label.Position=UDim2.new(0.5,0,0,70);label.Size=UDim2.fromOffset(350,32)
    label.BackgroundColor3=Color3.fromRGB(30,30,34);label.TextColor3=Color3.fromRGB(235,235,240)
    label.Text='Test overlay: registered below the menu';label.TextSize=13;label.BorderSizePixel=0;label.Parent=root
    right:Toggle({Name='Test overlay',Flag='demo_overlay',Default=false,Callback=function(on: boolean)controller:SetEnabled(on)end})
    local containers=nav:Tab({Name='Containers',Icon='columns-2'})
    local pages=containers:Section({Name='Tabbed section',Side='Left'})
    pages:Page('First'):Paragraph({Title='First',Body='Test controls do not change the game.'})
    pages:Page('Second'):Label({Text='Second'})
    local console=containers:Section({Name='Console',Side='Right'}):Console({Name='Test console',Flag='demo_console',MaxLines=50})
    console:Log('Luma UI Lib')
    local extras=nav:Tab({Name='Information',Icon='info'})
    extras:Section({Name='Player list',Side='Left'}):PlayerList({Name='Players'})
    extras:Section({Name='Image',Side='Right'}):Image({Name='Image',Image='rbxthumb://type=AvatarHeadShot&id='..game:GetService('Players').LocalPlayer.UserId..'&w=150&h=150',Height=140})
    task.defer(function()
        W:SelectTab(tab)
        W:Notify({Title='Luma',Content='has been loaded.',Duration=3,Sound=false})
        print('[Luma Demo] Ready; RightShift opens/closes the menu; F2 toggle; F1 notification.')
    end)
    return W
end
