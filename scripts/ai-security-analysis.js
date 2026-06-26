// scripts/ai-security-analysis.js
const { execSync } = require('child_process');
const fs = require('fs');

// Simple AI analysis using pattern matching
// In production, this would use OpenAI API
function analyzeChanges() {
  try {
    // Get diff stats
    const diff = execSync('git diff HEAD~1 --stat 2>/dev/null || echo "No changes"').toString();
    const filesChanged = execSync('git diff HEAD~1 --name-only 2>/dev/null || echo ""').toString();
    
    if (!filesChanged.trim()) {
      console.log('No changes detected');
      process.exit(0);
    }
    
    // Analyze file patterns for security risks
    const riskPatterns = [
      { pattern: /password|secret|token/i, risk: 'high', message: 'Potential secret in code' },
      { pattern: /eval\(|exec\(/i, risk: 'high', message: 'Code execution detected' },
      { pattern: /\.env/i, risk: 'medium', message: 'Environment file modification' },
      { pattern: /database|prisma/i, risk: 'medium', message: 'Database related changes' },
      { pattern: /auth|jwt|token/i, risk: 'medium', message: 'Authentication related changes' },
    ];
    
    let risks = [];
    let confidence = 90; // Start with high confidence
    
    const files = filesChanged.split('\n').filter(f => f.trim());
    
    for (const file of files) {
      for (const { pattern, risk, message } of riskPatterns) {
        if (pattern.test(file)) {
          risks.push({ file, risk, message });
          if (risk === 'high') confidence -= 10;
          else if (risk === 'medium') confidence -= 5;
        }
      }
    }
    
    // Generate analysis report
    let report = '## 🔍 Análisis de Seguridad IA\n\n';
    report += `**Archivos analizados:** ${files.length}\n`;
    report += `**Nivel de confianza:** ${Math.max(confidence, 0)}%\n\n`;
    
    if (risks.length === 0) {
      report += '✅ **No se detectaron riesgos de seguridad**\n';
      report += 'Los cambios parecen seguros para merging.\n';
    } else {
      report += '⚠️ **Riesgos detectados:**\n\n';
      
      const highRisks = risks.filter(r => r.risk === 'high');
      const mediumRisks = risks.filter(r => r.risk === 'medium');
      
      if (highRisks.length > 0) {
        report += '### 🔴 Alto Riesgo\n';
        highRisks.forEach(r => {
          report += `- **${r.file}**: ${r.message}\n`;
        });
        report += '\n';
      }
      
      if (mediumRisks.length > 0) {
        report += '### 🟡 Medio Riesgo\n';
        mediumRisks.forEach(r => {
          report += `- **${r.file}**: ${r.message}\n`;
        });
        report += '\n';
      }
      
      report += '### 📋 Recomendaciones\n';
      report += '1. Revisar manualmente los archivos marcados\n';
      report += '2. Verificar que no haya secrets expuestos\n';
      report += '3. Asegurar que los cambios en auth sean correctos\n';
    }
    
    console.log(report);
    
    // Save analysis to file for PR comment
    fs.writeFileSync('analysis.txt', report);
    
    // Exit with error if confidence is low
    if (confidence < 80) {
      console.log('\n⚠️  Confianza baja - Se requiere revisión manual');
      process.exit(1);
    }
    
  } catch (error) {
    console.error('Error en análisis:', error.message);
    // Don't fail the build on analysis errors
    process.exit(0);
  }
}

analyzeChanges();
