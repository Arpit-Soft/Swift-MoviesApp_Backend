//
//  MoviesController..swift
//  
//
//  Created by Arpit Dixit on 10/09/21.
//

import Foundation
import Vapor

final class MoviesController {
    
    func create(_ req: Request) throws -> EventLoopFuture<Movie> {
        let movie = try req.content.decode(Movie.self)
        return movie.create(on: req.db).map { movie }
    }
    
    func all(_ req: Request) throws -> EventLoopFuture<[Movie]> {
        Movie.query(on: req.db).all()
    }
    
    // /movies/:movieId/reviews
    func getById(_ req: Request) throws -> EventLoopFuture<Movie> {
        Movie.query(on: req.db).filter(.id, .equal, req.parameters.get("movieId", as: UUID.self) ).with(\.$reviews).first().unwrap(or: Abort(.notFound))
        
    }
    
    // /movies/:movieId
    func delete(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Movie.find(req.parameters.get("movieId"), on: req.db).unwrap(or: Abort(.notFound))
            .flatMap {
                $0.delete(on: req.db)
        }.transform(to: .ok)
    }
}
