package backend.states;

import flixel.FlxG;
import flixel.FlxState;

class MusicBeatState extends FlxState
{
    // Timing and tracking metrics
    public static var bpm:Float = 100.0;
    
    public static var crotchet:Float = (60 / bpm); // Time duration of one beat in seconds
    public static var stepCrotchet:Float = (crotchet / 4); // Time duration of one step in seconds

    private var _lastTime:Float = 0;
    private var _curStep:Int = 0;
    private var _curBeat:Int = 0;
    private var _timeSync:Float = 0;

    public var curStep(get, null):Int;
    public var curBeat(get, null):Int;

    @:inline private function get_curStep():Int return _curStep;
    @:inline private function get_curBeat():Int return _curBeat;

    override public function create():Void
    {
        super.create();
        
        // Reset tracking metrics upon entering a fresh state
        _lastTime = 0;
        _curStep = 0;
        _curBeat = 0;
        _timeSync = 0;
    }

    override public function update(elapsed:Float):Void
    {
        // Track time based on the active playing song, or fall back to system delta time
        var currentTrackTime:Float = 0;

        if (FlxG.sound.music != null && FlxG.sound.music.playing) {
            currentTrackTime = FlxG.sound.music.time / 1000; // Convert milliseconds to seconds
        } else {
            _timeSync += elapsed;
            currentTrackTime = _timeSync;
        }

        // Run precision step calculations
        updateTrackMetrics(currentTrackTime);

        super.update(elapsed);
    }

    /**
     * Calculates step and beat updates precisely against current playback time.
     */
    private function updateTrackMetrics(time:Float):Void
    {
        // Recalculate timing thresholds dynamically if the BPM changed
        crotchet = (60 / bpm);
        stepCrotchet = (crotchet / 4);

        if (time < 0) time = 0;

        // Determine step index based on current playback position
        var rawStep:Int = Math.floor(time / stepCrotchet);

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
     * Dispatched automatically on every single step update event.
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
     * Dispatched automatically on every single beat update event.
     */
    public function beatHit(beat:Int):Void
    {
    }

    /**
     * Utility method to alter the global project BPM configurations cleanly.
     */
    public static function changeBPM(newBPM:Float):Void
    {
        bpm = newBPM;
        crotchet = (60 / bpm);
        stepCrotchet = (crotchet / 4);
    }
}
