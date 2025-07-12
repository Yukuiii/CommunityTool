package com.example.communitytool.dto;

import java.util.List;

import com.example.communitytool.pojo.Review;
import com.example.communitytool.pojo.Tool;

import lombok.Getter;

@Getter
public class ToolsReviewDTO {

    private Tool tool;
    private List<Review> reviews;

    public ToolsReviewDTO(Tool tool, List<Review> reviews) {
        this.tool = tool;
        this.reviews = reviews;
    }   

}
