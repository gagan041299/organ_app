class DropdownModel {
  List<LocType> locType;
  List<LoanType> loanType;
  List<PropType> propType;
  List<PropUsage> propUsage;
  List<Violation> violation;
  List<RemarksView> remarksView;
  List<Wing> wings;
  List<Zone> zone;
  List<Marketability> marketability;
  List<RelationPersonMetAtSite> relationPersonMetAtSite;
  List<Proximity> proximities;
  List<Accessibility> accessibility;
  List<Feedback> feedback;
  List<Boundaries> boundaries;
  List<PropertyOccupiedVacant> propertyOccupiedVacant;
  List<Cbd> cbd;
  List<Neighbourhood> neighbourhood;
  List<Infrastructure> infrastructure;
  List<DevelopmentLocality> developmentLocality;
  List<PhysicalStatusProperty> physicalStatusProperty;
  List<IndependentAccess> independentAccess;
  List<PlotDemarcated> plotDemarcated;
  List<RemarksProperty> remarksProperty;
  List<AmenitiesAvailableSociety> amenitiesAvailableSociety;
  List<ConstructionType> constructionType;
  List<NoWingsSociety> noWingsSociety;
  List<NoOfLifts> noOfLifts;
  List<Interior> interior;
  List<Flooring> flooring;
  List<Fittings> fittings;
  List<Doors> doors;
  List<Windows> window;
  List<MaintainanceLevel> maintenanceLevel;
  List<Exterior> exterior;
  List<ValuationDoneEarlier> valuationDoneEarlier;

  DropdownModel({
    required this.locType,
    required this.loanType,
    required this.propType,
    required this.propUsage,
    required this.violation,
    required this.remarksView,
    required this.wings,
    required this.zone,
    required this.marketability,
    required this.relationPersonMetAtSite,
    required this.proximities,
    required this.accessibility,
    required this.feedback,
    required this.boundaries,
    required this.propertyOccupiedVacant,
    required this.cbd,
    required this.neighbourhood,
    required this.infrastructure,
    required this.developmentLocality,
    required this.physicalStatusProperty,
    required this.independentAccess,
    required this.plotDemarcated,
    required this.remarksProperty,
    required this.amenitiesAvailableSociety,
    required this.constructionType,
    required this.noWingsSociety,
    required this.noOfLifts,
    required this.interior,
    required this.flooring,
    required this.fittings,
    required this.doors,
    required this.window,
    required this.maintenanceLevel,
    required this.exterior,
    required this.valuationDoneEarlier,
  });

  factory DropdownModel.fromJson(Map<String, dynamic> json) {
    return DropdownModel(
      locType:
          List<LocType>.from(json['loc_type'].map((x) => LocType.fromJson(x))),
      loanType: List<LoanType>.from(
          json['loan_type'].map((x) => LoanType.fromJson(x))),
      propType: List<PropType>.from(
          json['prop_type'].map((x) => PropType.fromJson(x))),
      propUsage: List<PropUsage>.from(
          json['prop_usage'].map((x) => PropUsage.fromJson(x))),
      violation: List<Violation>.from(
          json['violation'].map((x) => Violation.fromJson(x))),
      remarksView: List<RemarksView>.from(
          json['remarks_view'].map((x) => RemarksView.fromJson(x))),
      wings: List<Wing>.from(json['wings'].map((x) => Wing.fromJson(x))),
      zone: List<Zone>.from(json['zone'].map((x) => Zone.fromJson(x))),
      marketability: List<Marketability>.from(
          json['marketability'].map((x) => Marketability.fromJson(x))),
      relationPersonMetAtSite: List<RelationPersonMetAtSite>.from(
          json['relation_person_met_at_site']
              .map((x) => RelationPersonMetAtSite.fromJson(x))),
      proximities: List<Proximity>.from(
          json['proximities'].map((x) => Proximity.fromJson(x))),
      accessibility: List<Accessibility>.from(
          json['accessibility'].map((x) => Accessibility.fromJson(x))),
      feedback: List<Feedback>.from(
          json['feedback'].map((x) => Feedback.fromJson(x))),
      boundaries: List<Boundaries>.from(
          json['boundaries'].map((x) => Boundaries.fromJson(x))),
      propertyOccupiedVacant: List<PropertyOccupiedVacant>.from(
          json['property_occupied_vaccant']
              .map((x) => PropertyOccupiedVacant.fromJson(x))),
      cbd: List<Cbd>.from(json['cbd'].map((x) => Cbd.fromJson(x))),
      neighbourhood: List<Neighbourhood>.from(
          json['neighbourhood'].map((x) => Neighbourhood.fromJson(x))),
      infrastructure: List<Infrastructure>.from(
          json['infrastructure'].map((x) => Infrastructure.fromJson(x))),
      developmentLocality: List<DevelopmentLocality>.from(
          json['development_locality']
              .map((x) => DevelopmentLocality.fromJson(x))),
      physicalStatusProperty: List<PhysicalStatusProperty>.from(
          json['physical_status_property']
              .map((x) => PhysicalStatusProperty.fromJson(x))),
      independentAccess: List<IndependentAccess>.from(
          json['independent_access'].map((x) => IndependentAccess.fromJson(x))),
      plotDemarcated: List<PlotDemarcated>.from(
          json['plot_demarcated'].map((x) => PlotDemarcated.fromJson(x))),
      remarksProperty: List<RemarksProperty>.from(
          json['remarks_property'].map((x) => RemarksProperty.fromJson(x))),
      amenitiesAvailableSociety: List<AmenitiesAvailableSociety>.from(
          json['amenities_available_society']
              .map((x) => AmenitiesAvailableSociety.fromJson(x))),
      constructionType: List<ConstructionType>.from(
          json['construction_type'].map((x) => ConstructionType.fromJson(x))),
      noWingsSociety: List<NoWingsSociety>.from(
          json['no_wings_society'].map((x) => NoWingsSociety.fromJson(x))),
      noOfLifts: List<NoOfLifts>.from(
          json['no_of_lifts'].map((x) => NoOfLifts.fromJson(x))),
      interior: List<Interior>.from(
          json['interior'].map((x) => Interior.fromJson(x))),
      flooring: List<Flooring>.from(
          json['flooring'].map((x) => Flooring.fromJson(x))),
      fittings: List<Fittings>.from(
          json['fittings'].map((x) => Fittings.fromJson(x))),
      doors: List<Doors>.from(json['doors'].map((x) => Doors.fromJson(x))),
      window:
          List<Windows>.from(json['window'].map((x) => Windows.fromJson(x))),
      maintenanceLevel: List<MaintainanceLevel>.from(
          json['maintenance_level'].map((x) => MaintainanceLevel.fromJson(x))),
      exterior: List<Exterior>.from(
          json['exterior'].map((x) => Exterior.fromJson(x))),
      valuationDoneEarlier: List<ValuationDoneEarlier>.from(
          json['valuation_done_earlier']
              .map((x) => ValuationDoneEarlier.fromJson(x))),
    );
  }
}

class LocType {
  String id;
  String name;
  String code;

  LocType({
    required this.id,
    required this.name,
    required this.code,
  });

  factory LocType.fromJson(Map<String, dynamic> json) {
    return LocType(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class LoanType {
  int id;
  String name;

  LoanType({
    required this.id,
    required this.name,
  });

  factory LoanType.fromJson(Map<String, dynamic> json) {
    return LoanType(
      id: json['ID'],
      name: json['NAME'],
    );
  }
}

class PropType {
  int id;
  String name;
  String code;

  PropType({
    required this.id,
    required this.name,
    required this.code,
  });

  factory PropType.fromJson(Map<String, dynamic> json) {
    return PropType(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class PropUsage {
  int id;
  String name;
  String code;

  PropUsage({
    required this.id,
    required this.name,
    required this.code,
  });

  factory PropUsage.fromJson(Map<String, dynamic> json) {
    return PropUsage(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Violation {
  int id;
  String name;
  String code;

  Violation({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Violation.fromJson(Map<String, dynamic> json) {
    return Violation(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class RemarksView {
  int id;
  String name;
  String code;

  RemarksView({
    required this.id,
    required this.name,
    required this.code,
  });

  factory RemarksView.fromJson(Map<String, dynamic> json) {
    return RemarksView(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Wing {
  int id;
  String name;
  String code;

  Wing({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Wing.fromJson(Map<String, dynamic> json) {
    return Wing(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Zone {
  int id;
  String name;
  String code;

  Zone({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Marketability {
  int id;
  String name;
  String code;

  Marketability({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Marketability.fromJson(Map<String, dynamic> json) {
    return Marketability(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class RelationPersonMetAtSite {
  int id;
  String name;
  String code;

  RelationPersonMetAtSite({
    required this.id,
    required this.name,
    required this.code,
  });

  factory RelationPersonMetAtSite.fromJson(Map<String, dynamic> json) {
    return RelationPersonMetAtSite(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Proximity {
  int id;
  String name;
  String code;

  Proximity({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Proximity.fromJson(Map<String, dynamic> json) {
    return Proximity(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Accessibility {
  int id;
  String name;
  String code;

  Accessibility({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Accessibility.fromJson(Map<String, dynamic> json) {
    return Accessibility(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Feedback {
  int id;
  String name;
  String code;

  Feedback({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Boundaries {
  int id;
  String name;
  String code;

  Boundaries({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Boundaries.fromJson(Map<String, dynamic> json) {
    return Boundaries(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class PropertyOccupiedVacant {
  int id;
  String name;
  String code;

  PropertyOccupiedVacant({
    required this.id,
    required this.name,
    required this.code,
  });

  factory PropertyOccupiedVacant.fromJson(Map<String, dynamic> json) {
    return PropertyOccupiedVacant(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Cbd {
  int id;
  String name;
  String code;

  Cbd({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Cbd.fromJson(Map<String, dynamic> json) {
    return Cbd(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Neighbourhood {
  int id;
  String name;
  String code;

  Neighbourhood({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Neighbourhood.fromJson(Map<String, dynamic> json) {
    return Neighbourhood(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Infrastructure {
  int id;
  String name;
  String code;

  Infrastructure({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Infrastructure.fromJson(Map<String, dynamic> json) {
    return Infrastructure(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class DevelopmentLocality {
  int id;
  String name;
  String code;

  DevelopmentLocality({
    required this.id,
    required this.name,
    required this.code,
  });

  factory DevelopmentLocality.fromJson(Map<String, dynamic> json) {
    return DevelopmentLocality(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class PhysicalStatusProperty {
  int id;
  String name;
  String code;

  PhysicalStatusProperty({
    required this.id,
    required this.name,
    required this.code,
  });

  factory PhysicalStatusProperty.fromJson(Map<String, dynamic> json) {
    return PhysicalStatusProperty(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class IndependentAccess {
  int id;
  String name;
  String code;

  IndependentAccess({
    required this.id,
    required this.name,
    required this.code,
  });

  factory IndependentAccess.fromJson(Map<String, dynamic> json) {
    return IndependentAccess(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class PlotDemarcated {
  int id;
  String name;
  String code;

  PlotDemarcated({
    required this.id,
    required this.name,
    required this.code,
  });

  factory PlotDemarcated.fromJson(Map<String, dynamic> json) {
    return PlotDemarcated(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class RemarksProperty {
  int id;
  String name;
  String code;

  RemarksProperty({
    required this.id,
    required this.name,
    required this.code,
  });

  factory RemarksProperty.fromJson(Map<String, dynamic> json) {
    return RemarksProperty(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class AmenitiesAvailableSociety {
  int id;
  String name;
  String code;

  AmenitiesAvailableSociety({
    required this.id,
    required this.name,
    required this.code,
  });

  factory AmenitiesAvailableSociety.fromJson(Map<String, dynamic> json) {
    return AmenitiesAvailableSociety(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class ConstructionType {
  int id;
  String name;
  String code;

  ConstructionType({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ConstructionType.fromJson(Map<String, dynamic> json) {
    return ConstructionType(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class NoWingsSociety {
  int id;
  String name;
  String code;

  NoWingsSociety({
    required this.id,
    required this.name,
    required this.code,
  });

  factory NoWingsSociety.fromJson(Map<String, dynamic> json) {
    return NoWingsSociety(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class NoOfLifts {
  int id;
  String name;
  String code;

  NoOfLifts({
    required this.id,
    required this.name,
    required this.code,
  });

  factory NoOfLifts.fromJson(Map<String, dynamic> json) {
    return NoOfLifts(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Interior {
  int id;
  String name;
  String code;

  Interior({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Interior.fromJson(Map<String, dynamic> json) {
    return Interior(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Flooring {
  int id;
  String name;
  String code;

  Flooring({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Flooring.fromJson(Map<String, dynamic> json) {
    return Flooring(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Fittings {
  int id;
  String name;
  String code;

  Fittings({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Fittings.fromJson(Map<String, dynamic> json) {
    return Fittings(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Doors {
  int id;
  String name;
  String code;

  Doors({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Doors.fromJson(Map<String, dynamic> json) {
    return Doors(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Windows {
  int id;
  String name;
  String code;

  Windows({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Windows.fromJson(Map<String, dynamic> json) {
    return Windows(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class Exterior {
  int id;
  String name;
  String code;

  Exterior({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Exterior.fromJson(Map<String, dynamic> json) {
    return Exterior(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class MaintainanceLevel {
  int id;
  String name;
  String code;

  MaintainanceLevel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory MaintainanceLevel.fromJson(Map<String, dynamic> json) {
    return MaintainanceLevel(
      id: json['ID'],
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}

class ValuationDoneEarlier {
  int id;
  String name;
  String code;

  ValuationDoneEarlier({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ValuationDoneEarlier.fromJson(Map<String, dynamic> json) {
    return ValuationDoneEarlier(
      id: json['ID'] ?? -1,
      name: json['NAME'],
      code: json['CODE'] ?? '-1',
    );
  }
}
