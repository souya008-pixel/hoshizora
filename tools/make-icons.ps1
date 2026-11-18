# Generates the PWA icons (ASCII-only script for Windows PowerShell 5.1)
param([string]$Out = (Split-Path -Parent $PSScriptRoot))
Add-Type -AssemblyName System.Drawing

function New-Icon([int]$size, [string]$path, [double]$scale) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $rect = New-Object System.Drawing.Rectangle 0, 0, $size, $size
  $c1 = [System.Drawing.Color]::FromArgb(255, 32, 50, 110)
  $c2 = [System.Drawing.Color]::FromArgb(255, 7, 11, 29)
  $bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, $c1, $c2, 60.0
  $g.FillRectangle($bg, $rect)

  $s = $size * $scale          # drawing area (safe zone for maskable)
  $o = ($size - $s) / 2
  # crescent moon = big circle minus offset circle
  $R = $s * 0.30
  $mx = $o + $s * 0.46; $my = $o + $s * 0.52
  $p1 = New-Object System.Drawing.Drawing2D.GraphicsPath
  $p1.AddEllipse([single]($mx - $R), [single]($my - $R), [single](2 * $R), [single](2 * $R))
  $p2 = New-Object System.Drawing.Drawing2D.GraphicsPath
  $r2 = $R * 0.86
  $cx2 = $mx + $R * 0.48; $cy2 = $my - $R * 0.30
  $p2.AddEllipse([single]($cx2 - $r2), [single]($cy2 - $r2), [single](2 * $r2), [single](2 * $r2))
  $reg = New-Object System.Drawing.Region $p1
  $reg.Exclude($p2)
  $moon = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 255, 233, 168))
  $g.FillRegion($moon, $reg)

  # sparkles (4-point stars)
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
  $stars = @(@(0.74, 0.30, 0.075), @(0.82, 0.62, 0.045), @(0.30, 0.22, 0.04), @(0.62, 0.80, 0.035))
  foreach ($st in $stars) {
    $x = $o + $s * $st[0]; $y = $o + $s * $st[1]; $L = $s * $st[2]; $w = $L * 0.28
    $pts = @(
      (New-Object System.Drawing.PointF ([single]$x), ([single]($y - $L))),
      (New-Object System.Drawing.PointF ([single]($x + $w)), ([single]($y - $w))),
      (New-Object System.Drawing.PointF ([single]($x + $L)), ([single]$y)),
      (New-Object System.Drawing.PointF ([single]($x + $w)), ([single]($y + $w))),
      (New-Object System.Drawing.PointF ([single]$x), ([single]($y + $L))),
      (New-Object System.Drawing.PointF ([single]($x - $w)), ([single]($y + $w))),
      (New-Object System.Drawing.PointF ([single]($x - $L)), ([single]$y)),
      (New-Object System.Drawing.PointF ([single]($x - $w)), ([single]($y - $w)))
    )
    $g.FillPolygon($white, [System.Drawing.PointF[]]$pts)
  }
  $g.Dispose()
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
}

New-Icon 192 (Join-Path $Out 'icon-192.png') 1.0
New-Icon 512 (Join-Path $Out 'icon-512.png') 1.0
New-Icon 512 (Join-Path $Out 'icon-maskable-512.png') 0.78
New-Icon 180 (Join-Path $Out 'apple-touch-icon.png') 0.92
Write-Output "icons written to $Out"
