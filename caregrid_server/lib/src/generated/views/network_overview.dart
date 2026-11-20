/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:caregrid_server/src/generated/protocol.dart' as _ighx06pg;
import 'package:serverpod/serverpod.dart' as _is;
import '../views/campus_pulse.dart' as _iwz6sd2s;

/// Cross-campus operating picture for the network role.
abstract class NetworkOverview
    implements _is.SerializableModel, _is.ProtocolSerialization {
  NetworkOverview._({
    required this.generatedAt,
    required this.campuses,
  });

  factory NetworkOverview({
    required DateTime generatedAt,
    required List<_iwz6sd2s.CampusPulse> campuses,
  }) = _NetworkOverviewImpl;

  factory NetworkOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return NetworkOverview(
      generatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      campuses: _ighx06pg.Protocol().deserialize<List<_iwz6sd2s.CampusPulse>>(
        jsonSerialization['campuses'],
      ),
    );
  }

  DateTime generatedAt;

  List<_iwz6sd2s.CampusPulse> campuses;

  /// Returns a shallow copy of this [NetworkOverview]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NetworkOverview copyWith({
    DateTime? generatedAt,
    List<_iwz6sd2s.CampusPulse>? campuses,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NetworkOverview',
      'generatedAt': generatedAt.toJson(),
      'campuses': campuses.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NetworkOverview',
      'generatedAt': generatedAt.toJson(),
      'campuses': campuses.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _NetworkOverviewImpl extends NetworkOverview {
  _NetworkOverviewImpl({
    required DateTime generatedAt,
    required List<_iwz6sd2s.CampusPulse> campuses,
  }) : super._(
         generatedAt: generatedAt,
         campuses: campuses,
       );

  /// Returns a shallow copy of this [NetworkOverview]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NetworkOverview copyWith({
    DateTime? generatedAt,
    List<_iwz6sd2s.CampusPulse>? campuses,
  }) {
    return NetworkOverview(
      generatedAt: generatedAt ?? this.generatedAt,
      campuses: campuses ?? this.campuses.map((e0) => e0.copyWith()).toList(),
    );
  }
}
