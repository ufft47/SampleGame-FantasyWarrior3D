require "Manager"
require "Knight"
require "Mage"
require "Monster"
require "Actor"
require "GlobalVariables"
require "Piglet"
require "Slime"
require "Rat"
require "Dragon"
require "Archer"

local gloableZOrder = 1
local monsterCount = {dragon=3,slime=3,piglet=10,rat=3}
local EXIST_MIN_MONSTER = 6
kill_count = 0
show_count = 0
local KILL_MAX_MONSTER = 35
local showboss = false
local scheduleid

local GameMaster = class("GameMaster")

local size = cc.Director:getInstance():getWinSize()

function GameMaster:ctor()
	self._totaltime = 0
	self._logicFrq = 1.0
end

function GameMaster.create()
	local gm = GameMaster.new()
	gm:init()

	return gm
end

function GameMaster:init()
	self:AddHeros()
	self:addMonsters()
end

function GameMaster:update(dt)
    self._totaltime = self._totaltime + dt
	if self._totaltime > self._logicFrq then
		self._totaltime = self._totaltime - self._logicFrq
		self:logicUpdate()
	end
end

function GameMaster:logicUpdate()
    if show_count < KILL_MAX_MONSTER then
        local max_const_count = monsterCount.piglet + monsterCount.dragon + monsterCount.rat + monsterCount.slime
        local last_count = List.getSize(DragonPool) + List.getSize(SlimePool) + List.getSize(SlimePool) + List.getSize(PigletPool)
        if max_const_count - last_count < EXIST_MIN_MONSTER then
            self:randomshowMonster()
        end
    elseif kill_count == KILL_MAX_MONSTER and showboss == false then
        showboss = true
        self:showBoss()
    end
end

function GameMaster:AddHeros()

	local knight = Knight:create()
   	knight:setPosition(-1100, 250)
    currentLayer:addChild(knight)
    knight:idleMode()
    List.pushlast(HeroManager, knight)

	local mage = Mage:create()
   	mage:setPosition(-1200, 200)
   	currentLayer:addChild(mage)
   	mage:idleMode()
   	List.pushlast(HeroManager, mage)
   	
    local archer = Archer:create()
    archer:setPosition(-1200, 100)
    currentLayer:addChild(archer)
    archer:idleMode()
    List.pushlast(HeroManager, archer)   	

end

function GameMaster:addMonsters()
	self:addDragon()
	self:addSlime()
	self:addPiglet()
	self:addRat()
end

function GameMaster:addDragon()
    for var=1, monsterCount.dragon do
        local dragon = Dragon:create()
        currentLayer:addChild(dragon)
        dragon:setVisible(false)
        dragon:setAIEnabled(false)
        List.pushlast(DragonPool,dragon)
    end   
end

function GameMaster:addSlime()
    for var=1, monsterCount.slime do
    	local slime = Slime:create()
    	slime:retain()
    	List.pushlast(SlimePool,slime)
    end   
end

function GameMaster:addPiglet()
    for var=1, monsterCount.piglet do
    	local piglet = Piglet:create()
    	currentLayer:addChild(piglet)
    	piglet:setVisible(false)
    	piglet:setAIEnabled(false)
    	List.pushlast(PigletPool,piglet)
    end   
end

function GameMaster:addRat()
    for var=1, monsterCount.rat do
        local rat = Rat:create()
        currentLayer:addChild(rat)
        rat:setVisible(false)
        rat:setAIEnabled(false)
        List.pushlast(RatPool,rat)
    end  
end

function GameMaster:showDragon()
    if List.getSize(DragonPool) ~= 0 then
        local dragon = List.popfirst(DragonPool)
        dragon:reset()
        local appearPos = getFocusPointOfHeros()
        math.randomseed(tostring(os.time()):reverse():sub(1, 6))
        local randomvar = math.random()
        --cclog("the randomvar is %f",randomvar)
        if randomvar < 0.4 then appearPos.x = appearPos.x - 1200
        else appearPos.x = appearPos.x + 1200 end
        if appearPos.x < G.activearea.left then 
            appearPos.x = appearPos.x + 2400 
        end
        if appearPos.x > G.activearea.right then 
            appearPos.x = appearPos.x - 2400 
        end
        appearPos.y = appearPos.y -30 + randomvar*60
        dragon:setPosition(appearPos)
        dragon:setVisible(true)
        dragon:setAIEnabled(true)
        List.pushlast(MonsterManager, dragon)
        show_count = show_count + 1
    end
end

function GameMaster:showPiglet()
    if List.getSize(PigletPool) ~= 0 then
        local piglet = List.popfirst(PigletPool)
        piglet:reset()
        local appearPos = getFocusPointOfHeros()
        math.randomseed(tostring(os.time()):reverse():sub(1, 6))
        local randomvar = math.random()
        --cclog("the randomvar is %f",randomvar)
        if randomvar < 0.4 then appearPos.x = appearPos.x - 1200
        else appearPos.x = appearPos.x + 1200 end
        if appearPos.x < G.activearea.left then 
            appearPos.x = appearPos.x + 2400 
        end
        if appearPos.x > G.activearea.right then 
            appearPos.x = appearPos.x - 2400 
        end
        appearPos.y = appearPos.y -30 + randomvar*60
        piglet:setPosition(appearPos)
        piglet:setVisible(true)
        piglet:setAIEnabled(true)
        List.pushlast(MonsterManager, piglet)
        show_count = show_count + 1
    end
end

function GameMaster:showSlime()
	if List.getSize(SlimePool) ~= 0 then
        local slime = List.popfirst(SlimePool)
        slime:setPosition({x=800,y=100})
        currentLayer:addChild(slime)
        List.pushlast(MonsterManager, slime)
        kill_count = kill_count + 1
    end
end

function GameMaster:showRat()
    if List.getSize(RatPool) ~= 0 then
        local rat = List.popfirst(RatPool)
        rat:reset()
        local appearPos = getFocusPointOfHeros()
        math.randomseed(tostring(os.time()):reverse():sub(1, 6))
        local randomvar = math.random()
        --cclog("the randomvar is %f",randomvar)
        if randomvar < 0.4 then appearPos.x = appearPos.x - 1200
        else appearPos.x = appearPos.x + 1200 end
        if appearPos.x < G.activearea.left then 
            appearPos.x = appearPos.x + 2400 
        end
        if appearPos.x > G.activearea.right then 
            appearPos.x = appearPos.x - 2400 
        end
        appearPos.y = appearPos.y -30 + randomvar*60
        rat:setPosition(appearPos)
        rat:setVisible(true)
        rat:setAIEnabled(true)
        List.pushlast(MonsterManager, rat)
        show_count = show_count + 1
    end
end

function GameMaster:randomshowMonster()
	local random_var = math.random()
	if random_var<0.25 then
		self:showDragon()
	elseif random_var<0.5 then
		self:showPiglet()
	elseif random_var<0.75 then
		-- self:showSlime()
        self:showRat()
	else
		self:showRat()
	end
end

function GameMaster:showBoss()
    self:showWarning()
end

function GameMaster:showWarning()
	local warning = cc.Layer:create()
	local warning_logo = cc.Sprite:create("battlefieldUI/caution.png")
	warning_logo:setPosition(cc.p(100,200))
	warning_logo:setPositionZ(1)
	local function showdialog()
	   warning:removeFromParent()
	   self:showDialog()
	end
	warning_logo:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.EaseSineOut:create(cc.Blink:create(1.5,3)),cc.CallFunc:create(showdialog)))
	warning:addChild(warning_logo)
	
	warning:setScale(0.5)
    warning:setPosition({x=250,y=80})
    warning:setPositionZ(-cc.Director:getInstance():getZEye()/2)
    warning:ignoreAnchorPointForPosition(false)
    warning:setLocalZOrder(999)
    camera:addChild(warning,2)

end

function GameMaster:showDialog()
    local dialog = cc.Layer:create()
    local outframe = cc.Sprite:createWithSpriteFrameName("outframe.png")
    outframe:setPositionZ(1)
    dialog:addChild(outframe)
    local inframe = cc.Sprite:createWithSpriteFrameName("battlefieldUI/inframe.png")
    inframe:setPositionX(180)
    inframe:setPositionZ(2)
    dialog:addChild(inframe)
    local bossicon = cc.Sprite:createWithSpriteFrameName("bossicon.png")
    bossicon:setPosition(cc.p(-300,145))
    bossicon:setFlippedX(true)
    bossicon:setPositionZ(3)
    dialog:addChild(bossicon)
    local bosslogo = cc.Sprite:createWithSpriteFrameName("bosslogo.png")
    bosslogo:setPosition(cc.p(-300,-20))
    bosslogo:setPositionZ(4)
    dialog:addChild(bosslogo)
    local text = cc.Label:createWithSystemFont("引擎技术哪家强？","arial",40)
    text:setPosition(cc.p(200,0))
    text:setPositionZ(5)
    dialog:addChild(text)
    dialog:setAnchorPoint(cc.p(0.5,0.5))
    dialog:setPosition({x=300,y=50})
    dialog:setScale(0.1)
    dialog:setPositionZ(-cc.Director:getInstance():getZEye()/2)
    dialog:ignoreAnchorPointForPosition(false)
    dialog:setLocalZOrder(999)
    camera:addChild(dialog,2)
    local function pausegame()
        for var = HeroManager.first, HeroManager.last do
            HeroManager[var]:idleMode()
            HeroManager[var]:setAIEnabled(false)
        end
    end
    dialog:runAction(cc.Sequence:create(cc.ScaleTo:create(0.5,0.5),cc.CallFunc:create(pausegame)))
    uiLayer:setVisible(false)
    local function exitDialog( )
        local function removeDialog()
            dialog:removeFromParent()
            uiLayer:setVisible(true)
            for var = HeroManager.first, HeroManager.last do
                HeroManager[var]:setAIEnabled(true)
            end
        end
        dialog:runAction(cc.Sequence:create(cc.ScaleTo:create(0.5,0.1),cc.CallFunc:create(removeDialog)))
    	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleid)
    end
    
    scheduleid = cc.Director:getInstance():getScheduler():scheduleScriptFunc(exitDialog,3,false)
end

return GameMaster