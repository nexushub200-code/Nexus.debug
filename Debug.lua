local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local RS=game:GetService("RunService")
local TextService=game:GetService("TextService")
local LP=Players.LocalPlayer

local C={
	BG=Color3.fromRGB(8,4,10),
	P1=Color3.fromRGB(25,7,16),
	P2=Color3.fromRGB(43,9,22),
	Red=Color3.fromRGB(220,28,62),
	Red2=Color3.fromRGB(255,65,90),
	Purple=Color3.fromRGB(125,45,255),
	Purple2=Color3.fromRGB(190,85,255),
	White=Color3.fromRGB(248,242,246),
	Gray=Color3.fromRGB(155,135,145),
	Good=Color3.fromRGB(65,215,130),
	Bad=Color3.fromRGB(255,55,80)
}

local Checking=false
local Minimized=false

local function Corner(o,r)
	local x=Instance.new("UICorner")
	x.CornerRadius=UDim.new(0,r)
	x.Parent=o
end

local function Stroke(o,c,t,w)
	local x=Instance.new("UIStroke")
	x.Color=c
	x.Transparency=t or 0
	x.Thickness=w or 1
	x.Parent=o
	return x
end

local function Tween(o,t,p)
	local x=TS:Create(
		o,
		TweenInfo.new(t,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),
		p
	)
	x:Play()
	return x
end

local function Button(parent,text,pos,size)
	local b=Instance.new("TextButton")
	b.Position=pos
	b.Size=size
	b.BackgroundColor3=C.P2
	b.BorderSizePixel=0
	b.Text=text
	b.TextColor3=C.White
	b.TextSize=8
	b.Font=Enum.Font.GothamBold
	b.AutoButtonColor=false
	b.Parent=parent
	Corner(b,8)
	Stroke(b,C.Red,.45,1)
	return b
end

local GUI=Instance.new("ScreenGui")
GUI.Name="NexusDebugger"
GUI.ResetOnSpawn=false
GUI.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
GUI.Parent=game:GetService("CoreGui")

-- =========================================================
-- ROOT
-- TOTAL WIDTH = 350
-- =========================================================

local Root=Instance.new("Frame")
Root.Size=UDim2.fromOffset(350,300)
Root.Position=UDim2.new(.5,-175,.5,-150)
Root.BackgroundTransparency=1
Root.Parent=GUI

-- =========================================================
-- LEFT SCRIPT EDITOR
-- =========================================================

local Editor=Instance.new("Frame")
Editor.Size=UDim2.fromOffset(170,300)
Editor.Position=UDim2.fromOffset(0,0)
Editor.BackgroundColor3=C.BG
Editor.BorderSizePixel=0
Editor.ClipsDescendants=true
Editor.Parent=Root

Corner(Editor,12)
Stroke(Editor,C.Purple,.12,1.3)

local EG=Instance.new("UIGradient")
EG.Color=ColorSequence.new{
	ColorSequenceKeypoint.new(0,Color3.fromRGB(30,6,23)),
	ColorSequenceKeypoint.new(.5,C.BG),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(10,3,12))
}
EG.Rotation=25
EG.Parent=Editor

-- =========================================================
-- REAL SCRIPT SCROLLER
-- =========================================================

local Scroll=Instance.new("ScrollingFrame")
Scroll.Position=UDim2.fromOffset(5,5)
Scroll.Size=UDim2.new(1,-10,1,-10)
Scroll.BackgroundColor3=Color3.fromRGB(6,3,8)
Scroll.BorderSizePixel=0
Scroll.ClipsDescendants=true

-- BOTH SCROLLBARS
Scroll.ScrollingDirection=Enum.ScrollingDirection.XY
Scroll.ScrollBarThickness=5
Scroll.ScrollBarImageColor3=C.Purple
Scroll.ScrollBarImageTransparency=.05
Scroll.HorizontalScrollBarInset=Enum.ScrollBarInset.ScrollBar
Scroll.VerticalScrollBarInset=Enum.ScrollBarInset.ScrollBar

Scroll.CanvasPosition=Vector2.new(0,0)
Scroll.CanvasSize=UDim2.fromOffset(20,20)

Scroll.Parent=Editor
Corner(Scroll,9)
Stroke(Scroll,C.Purple,.58,1)

-- =========================================================
-- TEXT BOX
-- =========================================================

local Box=Instance.new("TextBox")
Box.Position=UDim2.fromOffset(7,7)
Box.Size=UDim2.fromOffset(145,280)
Box.BackgroundTransparency=1
Box.BorderSizePixel=0
Box.ClearTextOnFocus=false
Box.MultiLine=true
Box.Text=""
Box.PlaceholderText="Paste Lua script here..."
Box.PlaceholderColor3=Color3.fromRGB(90,70,95)

Box.TextColor3=Color3.fromRGB(230,220,232)
Box.TextSize=9
Box.Font=Enum.Font.Code

Box.TextXAlignment=Enum.TextXAlignment.Left
Box.TextYAlignment=Enum.TextYAlignment.Top
Box.TextWrapped=false

Box.Parent=Scroll

-- =========================================================
-- SCROLL SIZE FIX
-- =========================================================

local function UpdateCanvas()
	local viewportW=math.max(1,Scroll.AbsoluteSize.X-14)
	local viewportH=math.max(1,Scroll.AbsoluteSize.Y-14)

	local text=Box.Text
	if taxt=="" then
		Box.Size=UDim2.fromOffset(viewportW,viewportH)
		Scroll.CanvasSize=UDim2.fromOffset(viewportW,viewportH)
		return
	end

	local bounds=TextService:GetTextSize(
		text,
		Box.TextSize,
		Box.Font,
		Vector2.new(100000,100000)
	)

	local textW=math.max(viewportW,bounds.X+25)
	local textH=math.max(viewportH,bounds.Y+25)

	Box.Size=UDim2.fromOffset(textW,textH)
	Scroll.CanvasSize=UDim2.fromOffset(textW+14,textH+14)
end

Box:GetPropertyChangedSignal("Text"):Connect(function()
	task.defer(UpdateCanvas)
end)

Scroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	task.defer(UpdateCanvas)
end)

-- =========================================================
-- RIGHT MENU
-- =========================================================

local Main=Instance.new("Frame")
Main.Size=UDim2.fromOffset(180,300)
Main.Position=UDim2.fromOffset(170,0)
Main.BackgroundColor3=C.BG
Main.BorderSizePixel=0
Main.ClipsDescendants=true
Main.Parent=Root

Corner(Main,12)
local MainStroke=Stroke(Main,C.Red,.1,1.3)

local MG=Instance.new("UIGradient")
MG.Color=ColorSequence.new{
	ColorSequenceKeypoint.new(0,Color3.fromRGB(38,7,19)),
	ColorSequenceKeypoint.new(.5,C.BG),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(10,3,11))
}
MG.Rotation=135
MG.Parent=Main

-- =========================================================
-- HEADER
-- =========================================================

local Logo=Instance.new("Frame")
Logo.Size=UDim2.fromOffset(34,34)
Logo.Position=UDim2.fromOffset(8,8)
Logo.BackgroundColor3=C.Red
Logo.BorderSizePixel=0
Logo.Parent=Main
Corner(Logo,10)
local LogoStroke=Stroke(Logo,C.Purple2,.1,1.1)

local LG=Instance.new("UIGradient")
LG.Color=ColorSequence.new{
	ColorSequenceKeypoint.new(0,C.Red),
	ColorSequenceKeypoint.new(.5,C.Purple),
	ColorSequenceKeypoint.new(1,C.Red)
}
LG.Rotation=45
LG.Parent=Logo

local N=Instance.new("TextLabel")
N.Size=UDim2.fromScale(1,1)
N.BackgroundTransparency=1
N.Text="N"
N.TextColor3=C.White
N.TextSize=18
N.Font=Enum.Font.GothamBlack
N.Parent=Logo

local Title=Instance.new("TextLabel")
Title.Position=UDim2.fromOffset(48,8)
Title.Size=UDim2.new(1,-82,0,17)
Title.BackgroundTransparency=1
Title.Text="Nexus Debugger"
Title.TextColor3=C.White
Title.TextSize=10
Title.Font=Enum.Font.GothamBold
Title.TextXAlignment=Enum.TextXAlignment.Left
Title.Parent=Main

local Sub=Instance.new("TextLabel")
Sub.Position=UDim2.fromOffset(49,24)
Sub.Size=UDim2.new(1,-82,0,12)
Sub.BackgroundTransparency=1
Sub.Text="Lua Script Analyzer"
Sub.TextColor3=C.Gray
Sub.TextSize=6
Sub.Font=Enum.Font.Gotham
Sub.TextXAlignment=Enum.TextXAlignment.Left
Sub.Parent=Main

local Close=Button(
	Main,
	"×",
	UDim2.new(1,-36,0,9),
	UDim2.fromOffset(27,27)
)

Close.TextSize=15

-- =========================================================
-- STATUS
-- =========================================================

local Status=Instance.new("Frame")
Status.Position=UDim2.fromOffset(7,50)
Status.Size=UDim2.new(1,-14,0,48)
Status.BackgroundColor3=C.P1
Status.BorderSizePixel=0
Status.Parent=Main

Corner(Status,9)
Stroke(Status,C.Red,.55,1)

local ST=Instance.new("TextLabel")
ST.Position=UDim2.fromOffset(9,6)
ST.Size=UDim2.new(1,-18,0,10)
ST.BackgroundTransparency=1
ST.Text="STATUS"
ST.TextColor3=C.Gray
ST.TextSize=6
ST.Font=Enum.Font.GothamBold
ST.TextXAlignment=Enum.TextXAlignment.Left
ST.Parent=Status

local SV=Instance.new("TextLabel")
SV.Position=UDim2.fromOffset(9,21)
SV.Size=UDim2.new(1,-18,0,18)
SV.BackgroundTransparency=1
SV.Text="READY TO CHECK"
SV.TextColor3=C.White
SV.TextSize=8
SV.Font=Enum.Font.GothamBold
SV.TextXAlignment=Enum.TextXAlignment.Left
SV.Parent=Status

-- =========================================================
-- ANALYSIS
-- =========================================================

local Result=Instance.new("Frame")
Result.Position=UDim2.fromOffset(7,105)
Result.Size=UDim2.new(1,-14,0,91)
Result.BackgroundColor3=C.P1
Result.BorderSizePixel=0
Result.Parent=Main

Corner(Result,9)
Stroke(Result,C.Purple,.55,1)

local RTitle=Instance.new("TextLabel")
RTitle.Position=UDim2.fromOffset(9,6)
RTitle.Size=UDim2.new(1,-18,0,10)
RTitle.BackgroundTransparency=1
RTitle.Text="ANALYSIS"
RTitle.TextColor3=C.Gray
RTitle.TextSize=6
RTitle.Font=Enum.Font.GothamBold
RTitle.TextXAlignment=Enum.TextXAlignment.Left
RTitle.Parent=Result

local RScroll=Instance.new("ScrollingFrame")
RScroll.Position=UDim2.fromOffset(7,21)
RScroll.Size=UDim2.new(1,-14,1,-27)
RScroll.BackgroundTransparency=1
RScroll.BorderSizePixel=0
RScroll.ScrollingDirection=Enum.ScrollingDirection.Y
RScroll.ScrollBarThickness=3
RScroll.ScrollBarImageColor3=C.Purple
RScroll.CanvasSize=UDim2.fromOffset(0,0)
RScroll.Parent=Result

local RV=Instance.new("TextLabel")
RV.Position=UDim2.fromOffset(2,2)
RV.Size=UDim2.new(1,-8,0,50)
RV.BackgroundTransparency=1
RV.Text="No analysis yet."
RV.TextColor3=C.Gray
RV.TextSize=7
RV.Font=Enum.Font.Code
RV.TextWrapped=true
RV.TextXAlignment=Enum.TextXAlignment.Left
RV.TextYAlignment=Enum.TextYAlignment.Top
RV.Parent=RScroll

local function ResultText(text,color)
	RV.Text=text
	RV.TextColor3=color or C.Gray

	task.defer(function()
		local h=RV.TextBounds.Y+12
		RV.Size=UDim2.new(1,-8,0,math.max(50,h))
		RScroll.CanvasSize=UDim2.fromOffset(0,h+5)
	end)
end

-- =========================================================
-- BUTTON GRID
-- =========================================================

local Check=Button(
	Main,
	"CHECK SCRIPT",
	UDim2.fromOffset(7,202),
	UDim2.fromOffset(81,34)
)

local Clear=Button(
	Main,
	"CLEAR",
	UDim2.fromOffset(92,202),
	UDim2.fromOffset(81,34)
)

local Copy=Button(
	Main,
	"COPY",
	UDim2.fromOffset(7,240),
	UDim2.fromOffset(81,34)
)

local Reset=Button(
	Main,
	"RESET",
	UDim2.fromOffset(92,240),
	UDim2.fromOffset(81,34)
)

local Info=Instance.new("TextLabel")
Info.Position=UDim2.fromOffset(7,280)
Info.Size=UDim2.new(1,-14,0,10)
Info.BackgroundTransparency=1
Info.Text="Nexus Debugger • Analysis Only"
Info.TextColor3=C.Gray
Info.TextSize=5.5
Info.Font=Enum.Font.Gotham
Info.TextXAlignment=Enum.TextXAlignment.Center
Info.Parent=Main

-- =========================================================
-- RESTORE BUTTON
-- =========================================================

local Restore=Instance.new("TextButton")
Restore.Size=UDim2.fromOffset(50,50)
Restore.Position=UDim2.new(.5,-25,0,12)
Restore.BackgroundColor3=C.Red
Restore.BorderSizePixel=0
Restore.Text="N"
Restore.TextColor3=C.White
Restore.TextSize=20
Restore.Font=Enum.Font.GothamBlack
Restore.AutoButtonColor=false
Restore.Visible=false
Restore.Parent=GUI

Corner(Restore,14)
local RestoreStroke=Stroke(Restore,C.Purple2,.1,1.3)

local RG=Instance.new("UIGradient")
RG.Color=ColorSequence.new{
	ColorSequenceKeypoint.new(0,C.Red),
	ColorSequenceKeypoint.new(.5,C.Purple),
	ColorSequenceKeypoint.new(1,C.Red)
}
RG.Rotation=45
RG.Parent=Restore

-- =========================================================
-- HOVER
-- =========================================================

local function Hover(b)
	b.MouseEnter:Connect(function()
		Tween(b,.13,{
			BackgroundColor3=Color3.fromRGB(68,12,34)
		})
	end)

	b.MouseLeave:Connect(function()
		Tween(b,.13,{
			BackgroundColor3=C.P2
		})
	end)
end

Hover(Check)
Hover(Clear)
Hover(Copy)
Hover(Reset)
Hover(Close)

-- =========================================================
-- DRAG ROOT
-- =========================================================

local function Drag(frame)
	local dragging=false
	local startPos
	local startRoot

	frame.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1
		or input.UserInputType==Enum.UserInputType.Touch then

			dragging=true
			startPos=input.Position
			startRoot=Root.Position

			input.Changed:Connect(function()
				if input.UserInputState==Enum.UserInputState.End then
					dragging=false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if not dragging then return end

		if input.UserInputType==Enum.UserInputType.MouseMovement
		or input.UserInputType==Enum.UserInputType.Touch then

			local delta=input.Position-startPos

			Root.Position=UDim2.new(
				startRoot.X.Scale,
				startRoot.X.Offset+delta.X,
				startRoot.Y.Scale,
				startRoot.Y.Offset+delta.Y
			)
		end
	end)
end

Drag(Main)

-- =========================================================
-- COMPILE-ONLY LUA CHECK
-- DOES NOT EXECUTE THE SCRIPT
-- =========================================================

local function Analyze(code)
	local errors={}

	if code=="" or code:match("^%s*$") then
		table.insert(errors,"Script input is empty.")
		return errors
	end

	-- BEST METHOD:
	-- compile only, never call the returned function
	if type(loadstring)=="function" then
		local fn,err=loadstring(code)

		if fn then
			return errors
		end

		table.insert(errors,tostring(err or "Lua syntax error."))

		return errors
	end

	-- FALLBACK CHECKER
	-- Used only when loadstring is unavailable.

	local function count(pattern)
		local n=0
		for _ in code:gmatch(pattern) do
			n+=1
		end
		return n
	end

	-- Only detect obvious triple-equals.
	-- == is VALID Lua.
	if code:match("===") then
		table.insert(errors,"Invalid '===' operator.")
	end

	-- Basic brackets.
	if count("%(")~=count("%)") then
		table.insert(errors,"Possible unmatched parentheses.")
	end

	if count("%[")~=count("%]") then
		table.insert(errors,"Possible unmatched square brackets.")
	end

	if count("{")~=count("}") then
		table.insert(errors,"Possible unmatched curly brackets.")
	end

	-- Basic block balance.
	local functionCount=count("%f[%a]function%f[%A]")
	local ifCount=count("%f[%a]if%f[%A]")
	local forCount=count("%f[%a]for%f[%A]")
	local whileCount=count("%f[%a]while%f[%A]")
	local doCount=count("%f[%a]do%f[%A]")
	local endCount=count("%f[%a]end%f[%A]")

	local blocks=
		functionCount+
		ifCount+
		forCount+
		whileCount+
		doCount

	if endCount>blocks then
		table.insert(errors,"Possible unexpected 'end' keyword.")
	elseif blocks>endCount then
		table.insert(errors,"Possible missing 'end' keyword.")
	end

	return errors
end

-- =========================================================
-- CHECK SCRIPT
-- =========================================================

Check.MouseButton1Click:Connect(function()
	if Checking then return end

	Checking=true
	Check.Text="CHECKING..."

	SV.Text="ANALYZING..."
	SV.TextColor3=C.Purple2

	ResultText("Scanning Lua syntax...",C.Gray)

	task.wait(.35)

	local errors=Analyze(Box.Text)

	if #errors==0 then

		SV.Text="NO ERROR FOUND"
		SV.TextColor3=C.Good

		ResultText(
			"✓ No syntax errors found.\n\nCompile check completed.",
			C.Good
		)

	else

		SV.Text="ERROR FOUND"
		SV.TextColor3=C.Bad

		local output="Errors found: "..#errors.."\n\n"

		for i,v in ipairs(errors) do
			output=output..i..". "..v.."\n"
		end

		ResultText(output,C.Bad)
	end

	Check.Text="CHECK SCRIPT"
	Checking=false
end)

-- =========================================================
-- CLEAR
-- =========================================================

Clear.MouseButton1Click:Connect(function()
	Box.Text=""
	Scroll.CanvasPosition=Vector2.new(0,0)

	SV.Text="READY TO CHECK"
	SV.TextColor3=C.White

	ResultText("No analysis yet.",C.Gray)
end)

-- =========================================================
-- COPY
-- =========================================================

Copy.MouseButton1Click:Connect(function()

	if Box.Text=="" then
		SV.Text="NOTHING TO COPY"
		SV.TextColor3=C.Bad
		return
	end

	if setclipboard then

		local ok=pcall(function()
			setclipboard(Box.Text)
		end)

		if ok then
			SV.Text="COPIED"
			SV.TextColor3=C.Good
		else
			SV.Text="COPY FAILED"
			SV.TextColor3=C.Bad
		end

	else
		SV.Text="COPY NOT AVAILABLE"
		SV.TextColor3=C.Bad
	end

	task.delay(1,function()
		SV.Text="READY TO CHECK"
		SV.TextColor3=C.White
	end)
end)

-- =========================================================
-- RESET
-- =========================================================

Reset.MouseButton1Click:Connect(function()
	Box.Text=""

	Scroll.CanvasPosition=Vector2.new(0,0)
	RScroll.CanvasPosition=Vector2.new(0,0)

	SV.Text="READY TO CHECK"
	SV.TextColor3=C.White

	ResultText("No analysis yet.",C.Gray)
end)

-- =========================================================
-- CLOSE / MINIMIZE
-- =========================================================

Close.MouseButton1Click:Connect(function()

	if Minimized then return end
	Minimized=true

	Tween(Root,.25,{
		Size=UDim2.fromOffset(5,5)
	})

	task.wait(.22)

	Root.Visible=false
	Restore.Visible=true

	Restore.Size=UDim2.fromOffset(8,8)
	Restore.BackgroundTransparency=1

	Tween(Restore,.3,{
		Size=UDim2.fromOffset(50,50),
		BackgroundTransparency=0
	})
end)

-- =========================================================
-- RESTORE
-- =========================================================

Restore.MouseButton1Click:Connect(function()

	if not Minimized then return end
	Minimized=false

	Restore.Visible=false
	Root.Visible=true

	Root.Size=UDim2.fromOffset(5,5)

	Tween(Root,.32,{
		Size=UDim2.fromOffset(350,300)
	})

	task.defer(UpdateCanvas)
end)

-- =========================================================
-- RESTORE BUTTON DRAG
-- =========================================================

do
	local dragging=false
	local startPos
	local startRestore

	Restore.InputBegan:Connect(function(input)

		if input.UserInputType==Enum.UserInputType.MouseButton1
		or input.UserInputType==Enum.UserInputType.Touch then

			dragging=true
			startPos=input.Position
			startRestore=Restore.Position

			input.Changed:Connect(function()
				if input.UserInputState==Enum.UserInputState.End then
					dragging=false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)

		if not dragging then return end

		if input.UserInputType==Enum.UserInputType.MouseMovement
		or input.UserInputType==Enum.UserInputType.Touch then

			local delta=input.Position-startPos

			Restore.Position=UDim2.new(
				startRestore.X.Scale,
				startRestore.X.Offset+delta.X,
				startRestore.Y.Scale,
				startRestore.Y.Offset+delta.Y
			)
		end
	end)
end

-- =========================================================
-- ANIMATION
-- =========================================================

local t=0

RS.RenderStepped:Connect(function(dt)

	t+=dt

	local v=(math.sin(t*2)+1)/2

	MainStroke.Color=C.Red:Lerp(C.Purple,v)
	LogoStroke.Color=C.Purple2:Lerp(C.Red,v)
	RestoreStroke.Color=C.Red:Lerp(C.Purple2,v)

end)

task.defer(UpdateCavas)
