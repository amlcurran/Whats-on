import CoreLocation

protocol EventView: class {

    func eventDeleted()

    func showDeleteError()

    func eventUpdated()

    func failedToUpdate()

    func expandMap()

    func collapseMap()

    func display(_ location: CLLocation)

}