import '../../core/utils/money.dart';
import 'debt_planner.dart';

class HealthScoreResult {
  const HealthScoreResult({
    required this.totalScore,
    required this.grade,
    required this.dsrScore,
    required this.savingsScore,
    required this.emergencyFundScore,
    required this.bnplSafetyScore,
    required this.summary,
    required this.recommendations,
  });

  /// 0 to 100
  final int totalScore;

  /// 'A' (85+), 'B' (70-84), 'C' (50-69), 'D' (<50)
  final String grade;

  final int dsrScore; // max 35
  final int savingsScore; // max 25
  final int emergencyFundScore; // max 25
  final int bnplSafetyScore; // max 15

  final String summary;
  final List<String> recommendations;
}

abstract final class FinancialHealthEngine {
  static HealthScoreResult evaluate({
    required Money netSalary,
    required Money totalCommitments,
    required Money currentEmergencyFund,
    required Money monthlySavingsTarget,
    required List<CommitmentItem> activeCommitments,
  }) {
    if (netSalary.sen <= 0) {
      return const HealthScoreResult(
        totalScore: 0,
        grade: 'N/A',
        dsrScore: 0,
        savingsScore: 0,
        emergencyFundScore: 0,
        bnplSafetyScore: 0,
        summary: 'Enter your monthly salary to calculate your score.',
        recommendations: ['Complete salary and profile setup.'],
      );
    }

    final List<String> recs = [];

    // DSR Score (max 35)
    final double dsr = totalCommitments.sen / netSalary.sen;
    int dsrScore = 0;
    if (dsr <= 0.30) {
      dsrScore = 35;
    } else if (dsr <= 0.40) {
      dsrScore = 28;
    } else if (dsr <= 0.50) {
      dsrScore = 18;
      recs.add('Your DSR is above 40%. Pause any new installments.');
    } else if (dsr <= 0.60) {
      dsrScore = 8;
      recs.add('High commitment burden! Focus on clearing smallest loans.');
    } else {
      dsrScore = 0;
      recs.add('Critical debt ratio (>60%). Risk of loan rejection and cashflow crisis.');
    }

    // Savings Score (max 25)
    final double savingsRate = monthlySavingsTarget.sen / netSalary.sen;
    int savingsScore = 0;
    if (savingsRate >= 0.20) {
      savingsScore = 25;
    } else if (savingsRate >= 0.15) {
      savingsScore = 20;
    } else if (savingsRate >= 0.10) {
      savingsScore = 14;
      recs.add('Aim to increase savings from 10% to 20% once debts decrease.');
    } else if (savingsRate >= 0.05) {
      savingsScore = 7;
      recs.add('Savings rate is under 10%. Try cutting back on dining out.');
    } else {
      savingsScore = 0;
      recs.add('Zero or near-zero savings! Start with RM 50/month to build the habit.');
    }

    // Emergency Fund Score (max 25; target 3 months net salary)
    final int targetFundSen = netSalary.sen * 3;
    final double fundRatio = targetFundSen > 0
        ? (currentEmergencyFund.sen / targetFundSen).clamp(0.0, 1.0)
        : 0.0;
    final int emergencyScore = (fundRatio * 25).round();
    if (fundRatio < 0.33) {
      recs.add('Build at least 1 full month of emergency buffer in a separate savings account.');
    }

    // BNPL Safety Score (max 15)
    int bnplScore = 15;
    final bnplCount = activeCommitments
        .where((c) =>
            !c.isPaidOff &&
            (c.type == CommitmentType.spayLater ||
                c.type == CommitmentType.sLoan))
        .length;
    if (bnplCount == 1) {
      bnplScore = 12;
    } else if (bnplCount == 2) {
      bnplScore = 7;
      recs.add('You have 2 active BNPL plans. Avoid adding a 3rd to keep cashflow clear.');
    } else if (bnplCount >= 3) {
      bnplScore = 0;
      recs.add('Warning: Multiple stacked BNPL plans detected. Accelerate pay-offs.');
    }

    final int total = dsrScore + savingsScore + emergencyScore + bnplScore;
    final String grade;
    final String summary;

    if (total >= 85) {
      grade = 'A';
      summary = 'Excellent financial standing for a fresh graduate! Keep this discipline.';
    } else if (total >= 70) {
      grade = 'B';
      summary = 'Solid foundation. A few minor tweaks will optimize your wealth building.';
    } else if (total >= 50) {
      grade = 'C';
      summary = 'Fair, but vulnerable to unexpected emergencies. Build your cash buffer.';
    } else {
      grade = 'D';
      summary = 'High financial strain. Restructure commitments and curb lifestyle spend.';
    }

    return HealthScoreResult(
      totalScore: total,
      grade: grade,
      dsrScore: dsrScore,
      savingsScore: savingsScore,
      emergencyFundScore: emergencyScore,
      bnplSafetyScore: bnplScore,
      summary: summary,
      recommendations: recs.isEmpty ? ['Maintain your current savings and budget discipline!'] : recs,
    );
  }
}
