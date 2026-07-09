package backend.files;

import openfl.utils.Assets;
import flash.media.Sound;
import flash.display.BitmapData;

class Paths 
{
    inline public static var SOUND_EXT:String = "ogg";
    inline public static var IMAGE_EXT:String = "png";
    inline public static var FONT_EXT:String = "ttf";

    inline public static var ASSETS_ROOT:String = "assets";
    
    private static var _cachedImages:Map<String, BitmapData> = new Map();
    private static var _cachedSounds:Map<String, Sound> = new Map();

    /**
     * Clears all cached assets from memory to free up system resources.
     */
    public static function clearCache():Void 
    {
        _cachedImages.clear();
        _cachedSounds.clear();
    }

    /**
     * Core function to build a file path within a specific library folder.
     */
    inline public static function getPath(file:String, type:String, library:String = "shared"):String 
    {
        if (library == "shared")
            return '$ASSETS_ROOT/$type/$file';
            
        return '$library/$type/$file';
    }

    /**
     * Returns a direct path to an image file.
     */
    inline public static function imagePath(key:String, library:String = "shared"):String 
    {
        return getPath('$key.$IMAGE_EXT', 'images', library);
    }

    /**
     * Loads and returns an image (BitmapData). Uses cache if available.
     */
    public static function image(key:String, library:String = "shared"):BitmapData 
    {
        var path:String = imagePath(key, library);
        
        if (!_cachedImages.exists(path)) {
            if (Assets.exists(path, IMAGE)) {
                _cachedImages.set(path, Assets.getBitmapData(path));
            } else {
                trace('Warning: Image not found at $path');
                return null;
            }
        }
        return _cachedImages.get(path);
    }

    /**
     * Returns a direct path to a sound file.
     */
    inline public static function soundPath(key:String, library:String = "shared"):String 
    {
        return getPath('$key.$SOUND_EXT', 'sounds', library);
    }

    /**
     * Loads and returns a sound effect.
     */
    public static function sound(key:String, library:String = "shared"):Sound 
    {
        var path:String = soundPath(key, library);
        
        if (!_cachedSounds.exists(path)) {
            if (Assets.exists(path, SOUND)) {
                _cachedSounds.set(path, Assets.getSound(path));
            } else {
                trace('Warning: Sound not found at $path');
                return null;
            }
        }
        return _cachedSounds.get(path);
    }

    /**
     * Returns a direct path to a music track file.
     */
    inline public static function musicPath(key:String, library:String = "shared"):String 
    {
        return getPath('$key.$SOUND_EXT', 'music', library);
    }

    /**
     * Loads and returns a music track. Uses cache if available.
     */
    public static function music(key:String, library:String = "shared"):Sound 
    {
        var path:String = musicPath(key, library);
        
        if (!_cachedSounds.exists(path)) {
            if (Assets.exists(path, SOUND)) {
                _cachedSounds.set(path, Assets.getSound(path));
            } else {
                trace('Warning: Music not found at $path');
                return null;
            }
        }
        return _cachedSounds.get(path);
    }

    /**
     * Returns the path for data files like JSON, XML, or TXT.
     */
    inline public static function file(key:String, ext:String = "json", library:String = "shared"):String 
    {
        return getPath('$key.$ext', 'data', library);
    }

    /**
     * Returns the plain text content of a data file.
     */
    public static function getText(key:String, ext:String = "json", library:String = "shared"):String 
    {
        var path:String = file(key, ext, library);
        if (Assets.exists(path, TEXT)) {
            return Assets.getText(path);
        }
        trace('Warning: Text file not found at $path');
        return "";
    }

    /**
     * Returns the path to a font file.
     */
    inline public static function font(key:String, library:String = "shared"):String 
    {
        return getPath('$key.$FONT_EXT', 'fonts', library);
    }

    /**
     * Returns the path to a xml file.
     */
    inline public static function xml(key:String, library:String = "shared"):String 
    {
        return getPath('$key.xml', 'images', library);
    }

    /**
     * Easily target files located inside a level or stage folder.
     */
    inline public static function stageFile(stage:String, key:String, ext:String = "png"):String 
    {
        return '$ASSETS_ROOT/stages/$stage/$key.$ext';
    }
}
