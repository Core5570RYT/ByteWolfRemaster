package;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import openfl.Lib;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
#if windows
import Discord.DiscordClient;
#end
using StringTools;

class ByteBeep extends MusicBeatState
{
    var char:Character;
    var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('menuBG'));
    var defCurZoom:Float = 0.9;
    var curZoom:Float = 0.8;
    var camArrow:FlxCamera;
    var strumLineYPos:Int = FlxG.height - 165;
    var strumLineNotes:FlxTypedGroup<FlxSprite>;
    var charNum:Int = 0;
    var charHead:HealthIcon;
    var charName:String = "byte";
    var isBF:Bool = false;
    var camFollow:FlxObject;

    var sustainOnHoldLength:Float = 2;

    var curStage:String = 'urmom';

    var charInfo:FlxText;

    override function create()
    {
        Conductor.changeBPM(100);
		persistentUpdate = true;
        super.create();

        #if windows
        DiscordClient.changePresence("Playing With: ByteWolf", null,null,true);
        #end

        FlxG.sound.music.stop();
        FlxG.sound.playMusic(Paths.inst('tutorial'), 1);
        strumLineNotes = new FlxTypedGroup<FlxSprite>();

        camArrow = new FlxCamera();
        camArrow.bgColor.alpha = 0;

        char = new Character(0,0, 'byte');
        char.setGraphicSize(Std.int(char.width * 0.7));
        char.screenCenter();
        char.scrollFactor.set(0.95, 0.95);

        bg.screenCenter();
        bg.setGraphicSize(Std.int(bg.width * 1.2));
        bg.antialiasing = true;
        generateStaticArrows();

        charHead = new HealthIcon(charName);
        charHead.animation.curAnim.curFrame = 0;
        charHead.x = 100;
        charHead.screenCenter(Y);

        var camPos:FlxPoint = new FlxPoint(char.getGraphicMidpoint().x, char.getGraphicMidpoint().y);

        camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		add(camFollow);
        
        charInfo = new FlxText(20, charHead.getGraphicMidpoint().y + 40, 0, "Character : " + charName +"["+ charNum+"]", 24);
        charInfo.scrollFactor.set();
		charInfo.setFormat("VCR OSD Mono",24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        
        var controlsLmao:FlxText;
        controlsLmao = new FlxText(20, charHead.getGraphicMidpoint().y + 200, 2000, "", 24);
        controlsLmao.scrollFactor.set();
        controlsLmao.setFormat("VCR OSD Mono",24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

        if (FlxG.save.data.dfjk)
            controlsLmao.text = "Controls: \n[DFJK] / [Arrow keys].\n[SPACE] - Playing their Hey Anims\n[Z] / [C] - Changing their health icons";
            else
            controlsLmao.text = "Controls: \n[WASD] / [Arrow keys].\n[SPACE] - Playing their Hey Anims\n[Z] / [C] - Changing their health icons";

        charInfo.antialiasing = false;
        controlsLmao.antialiasing = false;

        //layershit
        add(bg);  
        add(char);
        add(charHead);
        add(charInfo);
        add(strumLineNotes);
        add(controlsLmao);

        FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
    }

    override function update(elapsed:Float) {
        if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

        super.update(elapsed);
                
        FlxG.camera.zoom = FlxMath.lerp(0.9, FlxG.camera.zoom, 0.95);

        keyShit();

        for (i in 0...strumLineNotes.length)
            {
                strumLineNotes.members[i].x = (FlxMath.lerp(410 + (i * strumLineNotes.members[i].width), strumLineNotes.members[i].x, 0.95));
            }

        if (FlxG.keys.justPressed.E)
            changeCharacter(1);
        if (FlxG.keys.justPressed.Q)
            changeCharacter(-1);
        if (FlxG.keys.justPressed.Z)
            changeIcon(-1);
        if (FlxG.keys.justPressed.C)
            changeIcon(1); 

        if (FlxG.keys.justPressed.SPACE)
            {
                heyAnims();
            }

        if (controls.BACK)
            {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                FlxG.switchState(new MainMenuState());
            }
    }

    function changeCharacter(addNu:Int = 0)
        {
            charNum += addNu;

            var charshit:String = "";

            if (charNum < 0)
                charNum = 2;
            if (charNum > 2)
                charNum = 0;

            switch (charNum)
                {
                    case 0:
                        remove(char);
                        char = new Character(0,0, 'byte');
                        char.setGraphicSize(Std.int(char.width * 0.7));
                        char.screenCenter();
                        char.scrollFactor.set(0.95, 0.95);
                        add(char);
                        remove(charHead);
                        charName = "byte";
                        charshit = "ByteWolf";
                        charHead = new HealthIcon(charName);
                        charHead.animation.curAnim.curFrame = 0;
                        charHead.x = 100;
                        charHead.screenCenter(Y);
                        add(charHead);
                        isBF = false;
                        charInfo.text = "Character : " + charName +"["+ charNum+"]";
                    case 1:
                        remove(char);
                        char = new Character(420,220, 'bf', true);
                        char.setGraphicSize(Std.int(char.width * 0.4));
                        char.scrollFactor.set(0.95, 0.95);
                        add(char);
                        remove(charHead);
                        charName = "bf";
                        charshit = "Boyfriend";
                        charHead = new HealthIcon(charName);
                        charHead.animation.curAnim.curFrame = 0;
                        charHead.x = 100;
                        charHead.screenCenter(Y);
                        add(charHead);
                        isBF = true;
                        charInfo.text = "Character : " + charName +"["+ charNum+"]";
                    case 2:
                        remove(char);
                        char = new Character(0,0, 'gf');
                        char.setGraphicSize(Std.int(char.width * 0.7));
                        char.screenCenter();
                        char.scrollFactor.set(0.95, 0.95);
                        remove(charHead);
                        charName = "gf";
                        charshit = "Girlfriend";
                        charHead = new HealthIcon(charName);
                        charHead.animation.curAnim.curFrame = 0;
                        charHead.x = 100;
                        charHead.screenCenter(Y);
                        add(charHead);
                        add(char);
                        isBF = false;
                        charInfo.text = "Character : " + charName +"["+ charNum+"]";

                    #if windows
                    DiscordClient.changePresence("Playing With: " + charshit, null,null,true);
                    #end
                }
        }

    private function keyShit() {
        var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
        var pressArray:Array<Bool> = [
            controls.LEFT_P,
            controls.DOWN_P,
            controls.UP_P,
            controls.RIGHT_P
        ];
        var releaseArray:Array<Bool> = [
            controls.LEFT_R,
            controls.DOWN_R,
            controls.UP_R,
            controls.RIGHT_R
        ];

        strumLineNotes.forEach(function(spr:FlxSprite)
            {

                if (pressArray[spr.ID] && spr.animation.curAnim.name != 'pressed')
                    spr.animation.play('confirm');
                if (!holdArray[spr.ID])
                    spr.animation.play('static');
     
                if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
                {
                    spr.centerOffsets();
                    spr.offset.x -= 13;
                    spr.offset.y -= 13;
                }
                else
                    spr.centerOffsets();
            });

        if (pressArray[0])
            {
                char.playAnim('singLEFT', true);
            }

        if (pressArray[1])
            {
                char.playAnim('singDOWN', true);
            }

        if (pressArray[2])
            {
                char.playAnim('singUP', true);
            }
        
        if (pressArray[3])
            {
                char.playAnim('singRIGHT', true);
            }
        }

    function heyAnims() {
        switch (char.curCharacter.toLowerCase())
            {
                case 'byte':
                    char.playAnim('byteHey', true);
                case 'bf':
                    char.playAnim('hey', true);
                case 'gf':
                    char.playAnim('cheer', true);
            }

        FlxG.sound.play(Paths.sound('fnf_bf_hey', "shared"));
    }

    function changeIcon(addNum:Int = 0)
        {
            charHead.animation.curAnim.curFrame += addNum;
            if (charHead.animation.curAnim.curFrame < 0)
                charHead.animation.curAnim.curFrame = 2;
            if (charHead.animation.curAnim.curFrame < 2)
                charHead.animation.curAnim.curFrame = 0;
        }

    private function generateStaticArrows():Void
        {
            for (i in 0...4)
            {
                // FlxG.log.add(i);
                var babyArrow:FlxSprite = new FlxSprite(0, strumLineYPos);
                babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets', 'shared');
                babyArrow.animation.addByPrefix('green', 'arrowUP');
                babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
                babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
                babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
                babyArrow.antialiasing = true;
                babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
                switch (Math.abs(i))
                {
                    case 0:
                        babyArrow.x += Note.swagWidth * 0;
                        babyArrow.animation.addByPrefix('static', 'arrowLEFT');
                        babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
                        babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
                    case 1:
                        babyArrow.x += Note.swagWidth * 1;
                        babyArrow.animation.addByPrefix('static', 'arrowDOWN');
                        babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
                        babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
                    case 2:
                        babyArrow.x += Note.swagWidth * 2;
                        babyArrow.animation.addByPrefix('static', 'arrowUP');
                        babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
                        babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
                    case 3:
                        babyArrow.x += Note.swagWidth * 3;
                        babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
                        babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
                        babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
                }
                babyArrow.updateHitbox();
                babyArrow.scrollFactor.set();
    
                babyArrow.ID = i;
    
                babyArrow.animation.play('static');
                babyArrow.x = 50;   
    
                strumLineNotes.add(babyArrow);
            }
        }
    override function beatHit()
        {
            super.beatHit();
            FlxG.camera.zoom += 0.015;
            camArrow.zoom += 0.4;

            if (!char.animation.curAnim.name.startsWith('sing'))
                {
                    char.playAnim('idle');
                    char.dance();
                }    
        }
}

