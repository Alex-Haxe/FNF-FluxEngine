package backend.states;

import flixel.FlxG;
import flixel.FlxSubState;

class MusicBeatSubstate extends FlxSubState
{
    private var _lastTime:Float = 0;
    private var _curStep:Int = 0;
    private var _curBeat:Int = 0;
    private var _timeSync:Float = 0;

    public var curStep(get, null):Int;
    public var curBeat(get, null):Int;

    @:inline private function get_curStep():Int return _curStep;
    @:inline private function get_curBeat():Int return _curBeat;

    public function new()
    {
        super();
        
        // Reset substate timing parameters
        _lastTime = 0;
        _curStep = 0;
        _curBeat = 0;
        _timeSync = 0;
    }

    override public function update(elapsed:Float):Void
    {
        var currentTrackTime:Float = 0;

        // Track audio progress if present, otherwise handle local timers
        if (FlxG.sound.music != null && FlxG.sound.music.playing) {
            currentTrackTime = FlxG.sound.music.time / 1000;
        } else {
            _timeSync += elapsed;
            currentTrackTime = _timeSync;
        }

        // Sync local substate metrics
        updateTrackMetrics(currentTrackTime);

        super.update(elapsed);
    }

    /**
     * Processes step and beat increments locally inside substate loops.
     */
    private function updateTrackMetrics(time:Float):Void
    {
        if (time < 0) time = 0;

        // Refer directly to base parent class global metric scales
        var rawStep:Int = Math.floor(time / MusicBeatState.stepCrotchet);

        if (rawStep != _curStep && rawStep >= 0) 
        {
            if (rawStep > _curStep + 1) {
                for (i in (_curStep + 1)...rawStep) {
                    _curStep = i;
                    stepHit(_curStep);
                }
            }

            _curStep = rawStep;
            stepHit(_curStep);
        }

        _lastTime = time;
    }

    /**
     * Dispatched automatically on every single substate step update event.
     */
    public function stepHit(step:Int):Void
    {
        var calculatedBeat:Int = Math.floor(step / 4);

        if (calculatedBeat != _curBeat) {
            _curBeat = calculatedBeat;
            beatHit(_curBeat);
        }
    }

    /**
     * Dispatched automatically on every single substate beat update event.
     */
    public function beatHit(beat:Int):Void
    {
        // nothing
    }
}
