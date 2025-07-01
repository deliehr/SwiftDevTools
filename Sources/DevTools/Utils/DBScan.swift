//
//  DBScan.swift
//  DevTools
//
//  Created by Dominik Liehr on 31.03.25.
//

import Foundation

public final class DBScan {
    public init() {}

    /// includeTime: if true, the time distance in seconds (scaled with timeWeight) is also respected
    public func distanceBetween(_ p1: DataPoint, _ p2: DataPoint, includeTime: Bool = false, timeWeight: CGFloat = 1.0) -> CGFloat {
        let spatialDistance = hypot(p1.location.x - p2.location.x, p1.location.y - p2.location.y)
        
        if includeTime, let p1Time = p1.time, let p2Time = p2.time {
            let timeInterval = abs(p1Time.timeIntervalSince(p2Time))
            let timeDistance = CGFloat(timeInterval) * timeWeight
            return sqrt(pow(spatialDistance, 2) + pow(timeDistance, 2))
        } else {
            return spatialDistance
        }
    }

    // Sucht alle Punkte, die innerhalb von epsilon von 'point' liegen.
    public func regionQuery(data: [DataPoint], point: DataPoint, epsilon: CGFloat, includeTime: Bool, timeWeight: CGFloat) -> [Int] {
        var result: [Int] = []
        for (index, other) in data.enumerated() {
            if distanceBetween(point, other, includeTime: includeTime, timeWeight: timeWeight) <= epsilon {
                result.append(index)
            }
        }
        return result
    }

    // Erweitert ein Cluster rekursiv, indem alle direkt erreichbaren Punkte hinzugefügt werden.
    public func expandCluster(data: [DataPoint],
                       index: Int,
                       neighborIndices: [Int],
                       clusterId: Int,
                       visited: inout Set<Int>,
                       clusterAssignments: inout [Int?],
                       epsilon: CGFloat,
                       minPoints: Int,
                       includeTime: Bool,
                       timeWeight: CGFloat) {
        
        // Weise den Startpunkt dem aktuellen Cluster zu.
        clusterAssignments[index] = clusterId
        var seeds = neighborIndices
        
        while !seeds.isEmpty {
            let currentIndex = seeds.removeFirst()
            
            if !visited.contains(currentIndex) {
                visited.insert(currentIndex)
                let result = regionQuery(data: data,
                                         point: data[currentIndex],
                                         epsilon: epsilon,
                                         includeTime: includeTime,
                                         timeWeight: timeWeight)
                if result.count >= minPoints {
                    // Neue Punkte, die noch nicht in seeds enthalten sind, hinzufügen.
                    for i in result where !seeds.contains(i) {
                        seeds.append(i)
                    }
                }
            }
            
            // Weist den Punkt dem Cluster zu, falls er noch keiner Gruppe zugeordnet ist oder zuvor als Rauschen markiert wurde.
            if clusterAssignments[currentIndex] == nil || clusterAssignments[currentIndex] == -1 {
                clusterAssignments[currentIndex] = clusterId
            }
        }
    }

    // Hauptfunktion für DBScan
    // Parameter:
    // - epsilon: Radius zur Bestimmung der Nachbarschaft. Der epsilon-Parameter definiert den maximalen Abstand, innerhalb dessen zwei Punkte als „Nachbarn“ gelten.
    // - minPoints: Mindestanzahl von Punkten, damit ein Punkt als Kernpunkt gilt
    // - includeTime und timeWeight: Steuern, ob und wie stark der Zeitunterschied in den Abstand einfließt
    //
    // Rückgabe: Ein Tupel bestehend aus einem Dictionary der Cluster (clusterId -> [DataPoint]) und einem Array von Rauschpunkten.
    public func dbscan(data: [DataPoint],
                epsilon: CGFloat,
                minPoints: Int,
                includeTime: Bool = false,
                timeWeight: CGFloat = 1.0) -> (clusters: [Int: [DataPoint]], noise: [DataPoint]) {
        
        var clusterId = 0
        var clusters = [Int: [DataPoint]]()
        var visited = Set<Int>()
        // clusterAssignments enthält für jeden Index den Cluster, dem der Punkt zugeordnet wurde. -1 steht für Rauschen.
        var clusterAssignments = Array<Int?>(repeating: nil, count: data.count)
        
        for (index, point) in data.enumerated() {
            if visited.contains(index) { continue }
            
            visited.insert(index)
            let neighborIndices = regionQuery(data: data,
                                              point: point,
                                              epsilon: epsilon,
                                              includeTime: includeTime,
                                              timeWeight: timeWeight)
            
            // Wenn die Nachbarschaft kleiner als minPoints ist, wird der Punkt als Rauschen markiert.
            if neighborIndices.count < minPoints {
                clusterAssignments[index] = -1
            } else {
                clusterId += 1
                expandCluster(data: data,
                              index: index,
                              neighborIndices: neighborIndices,
                              clusterId: clusterId,
                              visited: &visited,
                              clusterAssignments: &clusterAssignments,
                              epsilon: epsilon,
                              minPoints: minPoints,
                              includeTime: includeTime,
                              timeWeight: timeWeight)
            }
        }
        
        // Erstelle die Cluster und das Array der Rauschpunkte
        var noise = [DataPoint]()
        for (index, assignment) in clusterAssignments.enumerated() {
            if let assign = assignment, assign > 0 {
                clusters[assign, default: []].append(data[index])
            } else if assignment == -1 {
                noise.append(data[index])
            }
        }
        
        return (clusters, noise)
    }
}

extension DBScan {
    // Definition des Datenpunkts
    public struct DataPoint: Equatable {
        public var location: CGPoint
        public var time: Date?
        
        public init(location: CGPoint, time: Date? = nil) {
            self.location = location
            self.time = time
        }
    }
}
