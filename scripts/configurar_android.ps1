$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$manifest = Join-Path $root 'android\app\src\main\AndroidManifest.xml'
$widgetTest = Join-Path $root 'test\widget_test.dart'

if (-not (Test-Path $manifest)) {
    throw "No se encontro AndroidManifest.xml. Flutter create no termino correctamente."
}

$content = Get-Content -LiteralPath $manifest -Raw
$content = $content -replace 'android:label="domino_royale"', 'android:label="Domino Royale"'
Set-Content -LiteralPath $manifest -Value $content -Encoding UTF8

$testContent = @'
import 'package:flutter_test/flutter_test.dart';
import 'package:domino_royale/app.dart';

void main() {
  testWidgets('Domino Royale inicia correctamente', (tester) async {
    await tester.pumpWidget(const DominoRoyaleApp());

    expect(find.byType(DominoRoyaleApp), findsOneWidget);
  });
}
'@
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $widgetTest) | Out-Null
Set-Content -LiteralPath $widgetTest -Value $testContent -Encoding UTF8

Write-Host '[OK] Nombre Android configurado: Domino Royale'
Write-Host '[OK] Prueba widget_test.dart reparada para DominoRoyaleApp'
Write-Host '[OK] Los iconos mipmap fueron generados por Flutter.'
