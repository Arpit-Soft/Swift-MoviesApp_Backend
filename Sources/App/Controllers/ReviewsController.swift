//
//  ReviewsController.swift
//  
//
//  Created by Arpit Dixit on 10/09/21.
//

import Foundation
import Vapor
import Fluent

final class ReviewsController {
    
    func create(_ req: Request) throws -> EventLoopFuture<Review> {
        
        let review = try req.content.decode(Review.self)
        return review.save(on: req.db).map { review }
        
    }
    
    func getByMovieId(_ req: Request) throws -> EventLoopFuture<[Review]> {
        
        guard let movieId = req.parameters.get("movieId", as: UUID.self) else {
            throw Abort(.notFound)
        }
        
        return Review.query(on: req.db).filter(\.$movie.$id, .equal, movieId)
            .with(\.$movie)
            .all()
        
    }
}
