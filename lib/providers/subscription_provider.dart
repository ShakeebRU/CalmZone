import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SubscriptionType { none, trial, monthly, yearly }

class SubscriptionProvider with ChangeNotifier {
  SubscriptionType _subscriptionType = SubscriptionType.none;
  DateTime? _trialStartDate;
  DateTime? _subscriptionEndDate;
  bool _trialUsed = false;

  SubscriptionType get subscriptionType => _subscriptionType;
  DateTime? get trialStartDate => _trialStartDate;
  DateTime? get subscriptionEndDate => _subscriptionEndDate;
  bool get trialUsed => _trialUsed;
  bool get hasActiveSubscription => _subscriptionType != SubscriptionType.none && 
      (_subscriptionEndDate == null || _subscriptionEndDate!.isAfter(DateTime.now()));

  SubscriptionProvider() {
    _loadSubscriptionData();
  }

  Future<void> _loadSubscriptionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _trialUsed = prefs.getBool('trial_used') ?? false;
    final subscriptionTypeIndex = prefs.getInt('subscription_type') ?? 0;
    _subscriptionType = SubscriptionType.values[subscriptionTypeIndex];
    
    final trialStart = prefs.getString('trial_start_date');
    if (trialStart != null) {
      _trialStartDate = DateTime.parse(trialStart);
    }
    
    final subEnd = prefs.getString('subscription_end_date');
    if (subEnd != null) {
      _subscriptionEndDate = DateTime.parse(subEnd);
    }
    
    notifyListeners();
  }

  Future<void> startTrial() async {
    if (_trialUsed) return;
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    _trialStartDate = now;
    _subscriptionEndDate = now.add(const Duration(days: 7));
    _subscriptionType = SubscriptionType.trial;
    _trialUsed = true;
    
    await prefs.setBool('trial_used', true);
    await prefs.setString('trial_start_date', now.toIso8601String());
    await prefs.setString('subscription_end_date', _subscriptionEndDate!.toIso8601String());
    await prefs.setInt('subscription_type', SubscriptionType.trial.index);
    
    notifyListeners();
  }

  Future<void> subscribe(SubscriptionType type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    _subscriptionType = type;
    
    if (type == SubscriptionType.monthly) {
      _subscriptionEndDate = now.add(const Duration(days: 30));
    } else if (type == SubscriptionType.yearly) {
      _subscriptionEndDate = now.add(const Duration(days: 365));
    }
    
    await prefs.setString('subscription_end_date', _subscriptionEndDate!.toIso8601String());
    await prefs.setInt('subscription_type', type.index);
    
    notifyListeners();
  }

  int getRemainingTrialDays() {
    if (_subscriptionType != SubscriptionType.trial || _subscriptionEndDate == null) {
      return 0;
    }
    final remaining = _subscriptionEndDate!.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining : 0;
  }
}

