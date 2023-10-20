$desktopEnvSource = @"
using System.Runtime.InteropServices;
public class DesktopEnv
{
  public const int SetDesktopWallpaper = 20;
  public const int SPI_SETACTIVEWINDOWTRACKING = 0x1001;
  public const int SPI_GETACTIVEWINDOWTRACKING = 0x1000;
  public const int SPI_SETACTIVEWNDTRKZORDER = 0x100D;
  public const int SPI_GETACTIVEWNDTRKZORDER = 0x100C;
  public const int SPI_SETACTIVEWNDTRKTIMEOUT = 0x2003;
  public const int SPI_GETACTIVEWNDTRKTIMEOUT = 0x2002;
  public const int SPI_SETMOUSESPEED = 0x0071;
  public const int SPI_GETMOUSESPEED = 0x0070;
  public const int UpdateIniFile = 0x01;
  public const int SendWinIniChange = 0x02;
  
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfo (uint uAction, uint uParam, uint pvParam, int fuWinIni);
  [DllImport("user32.dll", EntryPoint="SystemParametersInfo", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfoGet (uint uAction, uint uParam, ref uint pvParam, int fuWinIni);
  
  //true: X-Mouse on.  false: X-Mouse off.
  public static bool XMouse
  {
    get
    {
      uint booleanValue = 0;
      SystemParametersInfoGet( SPI_GETACTIVEWINDOWTRACKING, 0, ref booleanValue, 0 );
      return (booleanValue == 1)?true:false ;
    }
    set
    {
      SystemParametersInfo( SPI_SETACTIVEWINDOWTRACKING, 0, (uint)( (value)?1:0 ),
                            UpdateIniFile | SendWinIniChange );
    }
  }

  //1: The activated window will be brought to the top.
  //0: The activated window will not be brought to the top.
  public static bool XMouseBringToFront
  {
    get
    {
      uint booleanValue = 0;
      SystemParametersInfoGet( SPI_GETACTIVEWNDTRKZORDER, 0, ref booleanValue, 0 );
      return (booleanValue == 1)?true:false ;
    }
    set
    {
      SystemParametersInfo( SPI_SETACTIVEWNDTRKZORDER, 0, (uint)( (value)?1:0 ),
         UpdateIniFile | SendWinIniChange );
    }
  }

  //speed ranges from 1 to 20.  
  public static uint MouseSpeed
  {
    get
    {
      uint speed = 0;
      SystemParametersInfoGet( SPI_GETMOUSESPEED, 0, ref speed, 0 );
      return speed;
    }
    set
    {
      SystemParametersInfo( SPI_SETMOUSESPEED, 0, (uint)value, UpdateIniFile | SendWinIniChange );
    }
  }
  
  //delay to activate the window after mouse over in ms.
  public static uint XMouseTrackTimeout
  {
    get
    {
      uint intValue = 64;
      SystemParametersInfoGet( SPI_GETACTIVEWNDTRKTIMEOUT, 0, ref intValue, 0 );
      return intValue;
    }
    set
    {
      SystemParametersInfo( SPI_SETACTIVEWNDTRKTIMEOUT, 0, value, UpdateIniFile | SendWinIniChange );
    }
  }
}
"@

Add-Type -TypeDefinition $desktopEnvSource
Add-Type -AssemblyName System.Windows.Forms

$form1 = New-Object System.Windows.Forms.Form

$buttonOK = New-Object System.Windows.Forms.Button;
$buttonCancel = New-Object System.Windows.Forms.Button;
$checkboxEnableX = New-Object System.Windows.Forms.CheckBox;
$checkboxBringToFront = New-Object System.Windows.Forms.CheckBox;
$upDownTimeout = New-Object System.Windows.Forms.NumericUpDown;

$form1.Text = "X-Mouse Settings"
$form1.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog;
$form1.ClientSize = New-Object System.Drawing.Size( 230, 140 );
$form1.MinimizeBox = $false;
$form1.MaximizeBox = $false;

$buttonOK.Text = "OK";
$buttonOK.Location = New-Object System.Drawing.Point( 40, 100 );
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK;

$buttonCancel.Text = "Cancel";
$buttonCancel.Location = New-Object System.Drawing.Point( 120, 100 );
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel;

$checkboxEnableX.Location = New-Object System.Drawing.Point( 10, 10 );
$checkboxBringToFront.Location = New-Object System.Drawing.Point( 10, 34 );
$upDownTimeout.Location = New-Object System.Drawing.Point( 10, 66 );

$checkboxEnableX.Checked = [DesktopEnv]::XMouse;
$checkboxBringToFront.Checked = [DesktopEnv]::XMouseBringToFront;
$upDownTimeout.Minimum = 0;
$upDownTimeout.Maximum = 60000;
$upDownTimeout.Value = [DesktopEnv]::XMouseTrackTimeout;

$checkboxEnableX.Size = New-Object System.Drawing.Size( 200, 30 );
$checkboxBringToFront.Size = New-Object System.Drawing.Size( 200, 30 );
$upDownTimeout.Size = New-Object System.Drawing.Size( 200, 30 );

$checkboxEnableX.Text = "Enable X-Mouse";
$checkboxBringToFront.Text = "Bring Active Window to Front";

$form1.Controls.Add( $buttonOK );
$form1.Controls.Add( $buttonCancel );
$form1.Controls.Add( $checkboxEnableX );
$form1.Controls.Add( $checkboxBringToFront );
$form1.Controls.Add( $upDownTimeout );
$dr = $form1.ShowDialog();

switch( $dr )
{
  OK 
  { 
    echo $checkboxEnableX.Checked
    [DesktopEnv]::XMouse = $checkboxEnableX.Checked
    [DesktopEnv]::XMouseBringToFront = $checkboxBringToFront.Checked;
    [DesktopEnv]::XMouseTrackTimeout = $upDownTimeout.Value;
    echo "saved."
  }
  Cancel 
  {
    echo "canceled."
  }
}
