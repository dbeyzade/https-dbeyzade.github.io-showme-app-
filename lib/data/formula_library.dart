import 'package:showme/models/recognition_result.dart';

class FormulaEntry {
  final String formula;
  final String inventor;
  final String imageAsset;

  /// Optional aliases for OCR variations.
  final List<String> aliases;

  const FormulaEntry({
    required this.formula,
    required this.inventor,
    required this.imageAsset,
    this.aliases = const [],
  });
}

class FormulaLibrary {
  static const List<FormulaEntry> entries = [
    FormulaEntry(formula: 'E = mc²', inventor: 'Einstein', imageAsset: 'assets/images/Einstein.png', aliases: ['E=mc2', 'E = mc2']),
    FormulaEntry(formula: 'E = hf', inventor: 'Planck', imageAsset: 'assets/images/Planck.png', aliases: ['E=hf']),
    FormulaEntry(formula: 'E = ½mv²', inventor: 'Newton', imageAsset: 'assets/images/Newton.png', aliases: ['E=1/2mv2', 'E=0.5mv2', 'E=½mv2']),
    FormulaEntry(formula: 'E = mgh', inventor: 'Galileo', imageAsset: 'assets/images/Galileo.png', aliases: ['E=mgh']),
    FormulaEntry(formula: 'F = ma', inventor: 'Newton', imageAsset: 'assets/images/Newton.png', aliases: ['F=ma']),
    FormulaEntry(formula: 'F = GMm/r²', inventor: 'Newton', imageAsset: 'assets/images/Newton.png', aliases: ['F=GMm/r2']),
    FormulaEntry(formula: 'p = mv', inventor: 'Newton', imageAsset: 'assets/images/Newton.png', aliases: ['p=mv']),
    FormulaEntry(formula: 's = ½at²', inventor: 'Galileo', imageAsset: 'assets/images/Galileo.png', aliases: ['s=1/2at2', 's=0.5at2']),
    FormulaEntry(formula: 'v = u + at', inventor: 'Newton', imageAsset: 'assets/images/Newton.png', aliases: ['v=u+at']),
    FormulaEntry(formula: 'τ = rF sinθ', inventor: 'Archimedes', imageAsset: 'assets/images/Archimedes.png', aliases: ['tau=rFsinθ', 'tau=rFsin']),

    FormulaEntry(formula: 'F = kq₁q₂/r²', inventor: 'Coulomb', imageAsset: 'assets/images/Coulomb.png', aliases: ['F=kq1q2/r2']),
    FormulaEntry(formula: 'V = IR', inventor: 'Ohm', imageAsset: 'assets/images/Ohm.png', aliases: ['V=IR']),
    FormulaEntry(formula: 'P = IV', inventor: 'Joule', imageAsset: 'assets/images/Joule.png', aliases: ['P=IV']),

    FormulaEntry(formula: '∇·E = ρ/ε₀', inventor: 'Maxwell', imageAsset: 'assets/images/Maxwell.png', aliases: ['nabla·E=ρ/ε0', 'divE=ρ/ε0']),
    FormulaEntry(formula: '∇×B = μ₀J', inventor: 'Maxwell', imageAsset: 'assets/images/Maxwell.png', aliases: ['nabla×B=μ0J', 'curlB=μ0J']),
    FormulaEntry(formula: '∇·B = 0', inventor: 'Maxwell', imageAsset: 'assets/images/Maxwell.png', aliases: ['nabla·B=0', 'divB=0']),
    FormulaEntry(formula: '∇×E = -∂B/∂t', inventor: 'Faraday', imageAsset: 'assets/images/Faraday.png', aliases: ['nabla×E=-dB/dt', 'curlE=-dB/dt']),

    FormulaEntry(formula: 'F = qvB sinθ', inventor: 'Lorentz', imageAsset: 'assets/images/Lorentz.png', aliases: ['F=qvBsinθ']),
    FormulaEntry(formula: 'Φ = BA cosθ', inventor: 'Faraday', imageAsset: 'assets/images/Faraday.png', aliases: ['Phi=BAcosθ']),
    FormulaEntry(formula: 'ε = -dΦ/dt', inventor: 'Faraday', imageAsset: 'assets/images/Faraday.png', aliases: ['ε=-dΦ/dt', 'e=-dPhi/dt']),

    FormulaEntry(formula: 'PV = nRT', inventor: 'Clausius', imageAsset: 'assets/images/Clausius.png', aliases: ['PV=nRT']),
    FormulaEntry(formula: 'ΔU = Q - W', inventor: 'Clausius', imageAsset: 'assets/images/Clausius.png', aliases: ['ΔU=Q-W', 'dU=Q-W']),
    FormulaEntry(formula: 'ΔS ≥ 0', inventor: 'Clausius', imageAsset: 'assets/images/Clausius.png', aliases: ['ΔS>=0', 'dS>=0']),
    FormulaEntry(formula: 'S = k ln W', inventor: 'Boltzmann', imageAsset: 'assets/images/Boltzmann.png', aliases: ['S=klnW']),
    FormulaEntry(formula: 'F = U - TS', inventor: 'Helmholtz', imageAsset: 'assets/images/Helmholtz.png', aliases: ['F=U-TS']),

    FormulaEntry(formula: 'Ĥψ = Eψ', inventor: 'Schrödinger', imageAsset: 'assets/images/Schrödinger.png', aliases: ['Hψ=Eψ']),
    FormulaEntry(formula: 'λ = h/p', inventor: 'de Broglie', imageAsset: 'assets/images/de Broglie.png', aliases: ['lambda=h/p']),
    FormulaEntry(formula: 'E = hc/λ', inventor: 'Planck', imageAsset: 'assets/images/Planck.png', aliases: ['E=hc/lambda']),

    FormulaEntry(formula: 'L = T - V', inventor: 'Lagrange', imageAsset: 'assets/images/Lagrange.png', aliases: ['L=T-V']),
    FormulaEntry(formula: '∂L/∂q - d/dt(∂L/∂q̇) = 0', inventor: 'Lagrange', imageAsset: 'assets/images/Lagrange.png', aliases: ['dL/dq-d/dt(dL/dqdot)=0']),

    FormulaEntry(formula: 'W = Fd cosθ', inventor: 'Joule', imageAsset: 'assets/images/Joule.png', aliases: ['W=Fdcosθ']),

    FormulaEntry(formula: 'T = 2π√(m/k)', inventor: 'Hooke', imageAsset: 'assets/images/Hooke.png', aliases: ['T=2pi*sqrt(m/k)']),
    FormulaEntry(formula: 'F = -kx', inventor: 'Hooke', imageAsset: 'assets/images/Hooke.png', aliases: ['F=-kx']),

    FormulaEntry(formula: 'I = I₀cos²θ', inventor: 'Malus', imageAsset: 'assets/images/Malus.png', aliases: ['I=I0cos2θ']),

    FormulaEntry(formula: 'E² = (pc)² + (mc²)²', inventor: 'Einstein', imageAsset: 'assets/images/Einstein.png', aliases: ['E2=(pc)2+(mc2)2']),
    FormulaEntry(formula: 'γ = 1/√(1 - v²/c²)', inventor: 'Lorentz', imageAsset: 'assets/images/Lorentz.png', aliases: ['gamma=1/sqrt(1-v2/c2)']),
  ];

  static RecognitionResult? tryMatch(String rawText) {
    final normalized = _normalize(rawText);
    if (normalized.isEmpty) return null;

    FormulaEntry? best;
    int bestScore = 0;

    for (final entry in entries) {
      final keys = <String>[entry.formula, ...entry.aliases].map(_normalize);
      for (final key in keys) {
        if (key.isEmpty) continue;

        int score = 0;
        if (normalized == key) {
          score = 1000 + key.length;
        } else if (normalized.contains(key)) {
          score = 500 + key.length;
        } else if (key.contains(normalized) && normalized.length >= 8) {
          score = 200 + normalized.length;
        }

        if (score > bestScore) {
          bestScore = score;
          best = entry;
        }
      }
    }

    if (best == null) return null;

    return RecognitionResult.formula(
      formula: best.formula,
      inventor: best.inventor,
      imageAsset: best.imageAsset,
    );
  }

  static String _normalize(String input) {
    var s = input.toLowerCase();

    // common OCR cleanup
    s = s.replaceAll(' ', '');

    // unify symbols
    s = s
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('·', '.')
        .replaceAll('−', '-')
        .replaceAll('=', '=')
        .replaceAll('π', 'pi')
        .replaceAll('√', 'sqrt')
        .replaceAll('∇', 'nabla')
        .replaceAll('∂', 'd')
        .replaceAll('Φ', 'phi')
        .replaceAll('φ', 'phi')
        .replaceAll('θ', 'theta')
        .replaceAll('τ', 'tau')
        .replaceAll('λ', 'lambda')
        .replaceAll('ρ', 'rho')
        .replaceAll('σ', 'sigma')
        .replaceAll('μ', 'mu')
        .replaceAll('ε', 'eps')
        .replaceAll('γ', 'gamma')
        .replaceAll('Δ', 'delta')
        .replaceAll('ℏ', 'hbar')
        .replaceAll('ħ', 'hbar')
        .replaceAll('≥', '>=')
        .replaceAll('≤', '<=');

    // superscripts / subscripts
    s = s
        .replaceAll('²', '2')
        .replaceAll('³', '3')
        .replaceAll('⁴', '4')
        .replaceAll('₀', '0')
        .replaceAll('₁', '1')
        .replaceAll('₂', '2')
        .replaceAll('₃', '3')
        .replaceAll('₄', '4')
        .replaceAll('₅', '5')
        .replaceAll('₆', '6')
        .replaceAll('₇', '7')
        .replaceAll('₈', '8')
        .replaceAll('₉', '9')
        .replaceAll('½', '1/2');

    // remove trailing equals and anything after equals (common when user writes "=")
    if (s.contains('=')) {
      final parts = s.split('=');
      // keep left-hand side too (E=mc2 should keep full), but if user wrote result too,
      // we keep up to the first '=' then keep after? For matching, keep the full string,
      // but also accept left-only via contains.
      s = parts.join('=');
    }

    // keep safe charset
    s = s.replaceAll(RegExp(r'[^a-z0-9=+\-*/().<>\[\]]'), '');

    return s;
  }
}
