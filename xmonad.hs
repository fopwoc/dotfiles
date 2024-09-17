import XMonad
import XMonad hiding ( (|||) )

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageHelpers (isDialog,  doFullFloat, doCenterFloat, doRectFloat)

import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt

import XMonad.Layout.Spacing
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
import XMonad.Layout.MultiColumns
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.BinarySpacePartition

import XMonad.Actions.Navigation2D
import XMonad.Actions.UpdatePointer
import XMonad.Actions.GridSelect

import qualified XMonad.Layout.WindowNavigation as WinNavi
import qualified XMonad.Layout.IndependentScreens as LIS
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)

import Data.List
import Data.Monoid
import System.IO
import System.Exit

main = do
    xmproc <- spawnPipe "xmobar $HOME/.xmonad/xmobar.hs"
    xmonad $ ewmh $ defaultConfig -- gnomeConfig --defaultConfig
        { terminal = "alacritty"
        , manageHook = manageDocks
        <+> (isDialog --> doF W.swapUp)
        <+> insertPosition Below Newer
        <+> manageIdeaCompletionWindow 
        <+> manageHook defaultConfig 
        <+> composeAll 
            [ stringProperty "_NET_WM_NAME" =? "Emulator" --> doFloat
            , isDialog --> doCenterFloat  
            ]
        , layoutHook = myLayout
        , startupHook = startup, borderWidth = 2
        , normalBorderColor = "black"
        , focusedBorderColor = "orange"
        , handleEventHook = handleEventHook defaultConfig <+> docksEventHook
        , logHook = dynamicLogWithPP  xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "green" "" . shorten 50
            } >> updatePointer (0.5, 0.5) (0, 0)
        , modMask = mod4Mask --mod4Mask win	mod1Mask alt
        , keys = myKeys
        , mouseBindings = myMouseBindings
        }


myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm,                  xK_Return    ), spawn $ XMonad.terminal conf )

    -- Launch rofi
    , ((modm,                  xK_d         ), spawn "rofi -combi-modi window,drun,ssh -show combi -icon-theme \"Papirus\" -show-icons" )

    -- Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask,    xK_space     ), setLayout $ XMonad.layoutHook conf )

    -- Switch between layers
    , ((modm,                  xK_space     ), sendMessage NextLayout )

    -- Select opened app from grid
    , ((modm,                  xK_g         ), goToSelected defaultGSConfig )

    -- Resize viewed windows to the correct size
    , ((modm,                  xK_n         ), refresh )

    -- Move focus to the next window
    , ((modm,                  xK_Tab       ), windows W.focusDown )

    -- Move focus to the next window
    , ((modm .|. shiftMask,    xK_Tab       ), windows W.focusUp )

    -- Directional navigation of windows
    , ((modm,                  xK_Right     ),  windowGo R False )
    , ((modm,                  xK_Left      ),  windowGo L False )
    , ((modm,                  xK_Up        ),  windowGo U False )
    , ((modm,                  xK_Down      ),  windowGo D False )

    -- Swap adjacent windows
    , ((modm .|. shiftMask,    xK_Right     ), windowSwap R False )
    , ((modm .|. shiftMask,    xK_Left      ), windowSwap L False )
    , ((modm .|. shiftMask,    xK_Up        ), windowSwap U False )
    , ((modm .|. shiftMask,    xK_Down      ), windowSwap D False )
 
    -- Resize tiles
    , ((modm .|. shiftMask ,   xK_l         ), sendMessage $ ExpandTowards R )
    , ((modm .|. shiftMask ,   xK_h         ), sendMessage $ ExpandTowards L )
    , ((modm .|. shiftMask ,   xK_j         ), sendMessage $ ExpandTowards D )
    , ((modm .|. shiftMask ,   xK_k         ), sendMessage $ ExpandTowards U )


    -- Push window back into tiling
    , ((modm,                  xK_t         ), withFocused $ windows . W.sink )

    -- Rotate or Swap current tile
    , ((modm,                  xK_r         ), sendMessage Rotate )
    , ((modm,                  xK_s         ), sendMessage Swap )

    -- Fullscreen current tile
    , ((modm,                  xK_f         ), hackFullscreen )

    -- Envoke lockscreen
    , ((modm,                  xK_l         ), spawn "dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock" )

    -- Take screenshot
    , ((modm .|. shiftMask ,   xK_s         ), spawn "maim -s | xclip -selection clipboard -t image/png" )

    -- Close current tile
    , ((modm .|. shiftMask,    xK_q         ), kill )

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Quit xmonad.
    , ((modm .|. shiftMask,    xK_BackSpace ), confirmPrompt defaultXPConfig "exit" $ io (exitWith ExitSuccess) )
    ]
    ++
    [ ((m    .|. modm,         k            ), windows $ f i )
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    [ ((m    .|. modm,         key          ), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


-- Mouse binds
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, button1 ), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))
    , ((modm, button2 ), (\w -> focus w >> windows W.shiftMaster))
    , ((modm, button3 ), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))
    , ((modm, button4), (\_ -> windows W.focusUp ))
    , ((modm, button5), (\_ -> windows W.focusDown ))   
    ]

-- Android Studio Fix
(~=?) :: Eq a => Query [a] -> [a] -> Query Bool
q ~=? x = fmap (isInfixOf x) q

-- Do not treat menus and settings popup as a separate window.
manageIdeaCompletionWindow = (className =? "jetbrains-studio") <&&> (title ~=? "win") --> doIgnore


-- Fullscreen toggle
hackFullscreen :: X ()
hackFullscreen = do
    sendMessage ToggleStruts
    sendMessage ToggleLayout


-- My layouts
myLayout = avoidStruts  $ smartBorders $ toggleLayouts (noBorders Full) $ WinNavi.windowNavigation(emptyBSP) 
    ||| WinNavi.windowNavigation(Grid)
    ||| Tall 1 (3/100) (1/2)
    ||| Mirror (Tall 1 (3/100) (1/2))
    ||| Mirror (multiCol [1] 1 0.01 (-0.5))
    --spacingRaw True (Border 14 14 14 14) True (Border 14 14 14 14) True $ 


-- Startup hook
startup :: X ()
startup = do
    -- Intellij Idea fix
    setWMName "LG3D"

    -- Services startup
    spawn "gnome-screensaver"
    spawn "picom --config ~/.config/.picom.conf --backend xrender" --experimental-backend

    -- Monitor
    spawn "xrandr --output eDP --off --output DisplayPort-7 --auto --output DisplayPort-8 --auto"
    
    -- Keyboard
    spawn "setxkbmap -layout us,ru -option grp:caps_toggle" 
    spawn "xset r rate 240 24"

    -- Background
    spawn "feh feh --randomize --bg-fill /usr/share/backgrounds/"
