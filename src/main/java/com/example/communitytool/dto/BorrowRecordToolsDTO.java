package com.example.communitytool.dto;

import com.example.communitytool.pojo.BorrowRecord;
import com.example.communitytool.pojo.Tool;

import lombok.Getter;

@Getter
public class BorrowRecordToolsDTO {

    private BorrowRecord borrowRecord;
    private Tool tool;

    public BorrowRecordToolsDTO(BorrowRecord borrowRecord, Tool tool) {
        this.borrowRecord = borrowRecord;
        this.tool = tool;
    }
}
